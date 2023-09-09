from tkinter.messagebox import NO
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.db import connection


def call(query):
    try:
        cursor = connection.cursor()
        cursor.execute(query)
        return {'Status': 'Success'}

    except Exception as error:
        
        # Primary key violation
        if '_pkey' in str(error):
            return {'Error': 'Primary key violation'}

        # Primary key violation
        elif 'duplicate key value violates unique constraint' in str(error):
            return {'Error': 'Unique key violation'}

        # Foreign key violation
        elif 'violates foreign key constrain' in str(error):
            return {'Error': 'Foreign key violation'}
        
        # Custom error
        elif 'RAISE' in str(error):
            return {'Raised Error': str(error).split('\n')[0]}

        return {'Error:', str(error)}


def select(query):
    try:
        cursor = connection.cursor()
        cursor.execute(query)
        columns = [i[0] for i in cursor.description]                    # Get column names
        return [dict(zip(columns, row)) for row in cursor.fetchall()]   # Fetch data

    except Exception as error:
        return {'Error:', str(error)}


@api_view(['POST'])
def login(request):
    username = request.POST.get('username')
    password = request.POST.get('password')

    response = select(f"SELECT login('{username}', '{password}') AS token")

    if 'RAISE' in str(response):
        return Response({'Error': 'Invalid username or password'})
    return Response(response)


@api_view(['GET'])
def logout(request):
    token = request.query_params.get('token')
    select(f"SELECT logout('{token}')")
    return Response({'Status': 'Success'})


@api_view(['POST'])
def register(request):
    
    # Get post parameters
    association_number = request.POST.get('association_number')
    code = request.POST.get('code')
    type = request.POST.get('type')
    nurse_or_doctor = request.POST.get('nurse_or_doctor')

    if nurse_or_doctor != 'nurse': code, type = None, None
    if nurse_or_doctor != 'doctor': association_number = None

    response = call(f'''CALL register (
        '{request.POST.get('username')}', 
        '{request.POST.get('first_name')}', 
        '{request.POST.get('last_name')}', 
        {request.POST.get('gender')}, 
        '{request.POST.get('birth_date')}', 
        {request.POST.get('sickness_history')}, 
        '{request.POST.get('password')}', 
        '{association_number}', 
        '{code}', 
        '{type}', 
        '{nurse_or_doctor}'
    )''')

    return Response(response)


@api_view(['POST'])
def register_nurse(request):
    response = call(f'''CALL register_nurse (
        '{request.POST.get('username')}', 
        '{request.POST.get('type')}', 
        '{request.POST.get('code')}'
    )''')
    return Response(response)


@api_view(['POST'])
def register_doctor(request):
    response = call(f'''CALL register_doctor (
        '{request.POST.get('username')}', 
        '{request.POST.get('association_number')}'
    )''')
    return Response(response)


@api_view(['POST'])
def add_new_brand(request):

    return Response(call(f'''CALL add_new_brand (
        '{request.POST.get('name')}', 
        '{request.POST.get('institude')}', 
        '{request.POST.get('nationality')}',
        {request.POST.get('period')},
        '{request.POST.get('institude_type')}',
        {request.POST.get('dose_count')},
        '{request.META.get('HTTP_SESSION_TOKEN')}'
    )'''))


@api_view(['POST'])
def add_new_vaccination_center(request):

    return Response(call(f'''CALL add_new_vaccination_center (
        '{request.POST.get('name')}', 
        '{request.POST.get('address')}',
        '{request.META.get('HTTP_SESSION_TOKEN')}'
    )'''))


@api_view(['GET'])
def delete_account(request):
    return Response(call(f'''CALL delete_account (
        '{request.query_params.get('username')}',
        '{request.META.get('HTTP_SESSION_TOKEN')}'
    )'''))


@api_view(['POST'])
def add_new_vial(request):

    return Response(call(f'''CALL add_new_vial (
        '{request.POST.get('serial_number')}', 
        {request.POST.get('dose_counts')},
        '{request.POST.get('created_on')}',
        '{request.POST.get('brand_name')}',
        '{request.META.get('HTTP_SESSION_TOKEN')}'
    )'''))


@api_view(['POST'])
def make_injection(request):
    return Response(call(f'''CALL make_injection (
        '{request.POST.get('administrated_to')}',
        '{request.POST.get('time_stamp')}',
        '{request.POST.get('vaccination_center_name')}',
        {request.POST.get('serial_number')},
        '{request.META.get('HTTP_SESSION_TOKEN')}'
    )'''))


@api_view(['GET'])
def view_profile(request):
    return Response(select(f'''
    SELECT *
    FROM accounts
    FULL OUTER JOIN doctors USING(username)
    FULL OUTER JOIN nurses USING(username)
    WHERE username = (SELECT username FROM sessions WHERE token = '{request.META.get('HTTP_SESSION_TOKEN')}')
    '''))

@api_view(['POST'])
def change_password(request):
     return Response(call(f'''SELECT change_password (
        '{request.POST.get('old_password')}',
        '{request.POST.get('new_password')}',
        '{request.META.get('HTTP_SESSION_TOKEN')}'   
    )'''))


@api_view(['POST'])
def rate_administration(request):
     return Response(call(f'''SELECT rate_administration (
        '{request.POST.get('vaccination_center_name')}',
        {request.POST.get('score')},
        '{request.META.get('HTTP_SESSION_TOKEN')}'
    )'''))


@api_view(['GET'])
def view_vaccination_center_scores(request):
    return Response(select(f'''
        SELECT vaccination_center, score FROM view_vaccination_center_scores({request.query_params.get('page')})
    '''))


@api_view(['GET'])
def view_administrations_per_day(request):
    return Response(select(f'''
        SELECT time_stamp, COUNT(*) AS administrations
        FROM administrations
        GROUP BY time_stamp
        ORDER BY time_stamp DESC
    '''))


@api_view(['GET'])
def administrations_per_brand(request):
    return Response(select(f'''
        SELECT brand_name, COUNT(*) AS administrations
        FROM brands
        INNER JOIN vials
            ON brands.name = vials.brand_name
        INNER JOIN administrations
            ON vials.serial_number = administrations.vial_serial_number
        GROUP BY brand_name
    '''))


@api_view(['GET'])
def brands_centers_by_rate(request):
    return Response(select(f'''
        WITH vaccinations AS (
            SELECT administrations.*, brand_name
            FROM administrations
            INNER JOIN vials
                ON vials.serial_number = administrations.vial_serial_number
            INNER JOIN brands
                ON brands.name = vials.brand_name
        ), brand_center AS (
            SELECT brand_name, vaccination_center_name, SUM(score) AS score, ROW_NUMBER() OVER (PARTITION BY brand_name, vaccination_center_name ORDER BY brand_name, SUM(score)) AS r
            FROM vaccinations
            GROUP BY (brand_name, vaccination_center_name)
            ORDER BY brand_name, score
        )
        SELECT brand_name, vaccination_center_name, score
        FROM brand_center
        WHERE brand_center.r <= 3
    '''))


@api_view(['GET'])
def brands_centers_by_rate_personalized(request):
    return Response(select(f'''
        SELECT * FROM brands_centers_by_rate_personalized('{request.META.get('HTTP_SESSION_TOKEN')}')
    '''))