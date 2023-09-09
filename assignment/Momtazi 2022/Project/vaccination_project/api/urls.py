from .views import *
from django.urls import path

urlpatterns = [
    # Auth
    path('register', register, name = 'register'),
    path('register_nurse', register_nurse, name = 'register_nurse'),
    path('register_doctor', register_doctor, name = 'register_doctor'),
    path('login', login, name = 'login'),
    path('logout', logout, name = 'logout'),

    # API
    path('add_new_brand', add_new_brand, name = 'add_new_brand'),
    path('add_new_vaccination_center', add_new_vaccination_center, name = 'add_new_vaccination_center'),
    path('delete_account', delete_account, name = 'delete_account'),
    path('add_new_vial', add_new_vial, name = 'add_new_vial'),
    path('make_injection', make_injection, name = 'make_injection'),    
    path('view_profile', view_profile, name = 'view_profile'),
    path('change_password', change_password, name = 'change_password'),
    path('rate_administration', rate_administration, name = 'rate_administration'),
    path('view_vaccination_center_scores', view_vaccination_center_scores, name = 'view_vaccination_center_scores'),
    path('view_administrations_per_day', view_administrations_per_day, name = 'view_administrations_per_day'),
    path('administrations_per_brand', administrations_per_brand, name = 'administrations_per_brand'),
    path('brands_centers_by_rate', brands_centers_by_rate, name = 'brands_centers_by_rate'),
    path('brands_centers_by_rate_personalized', brands_centers_by_rate_personalized, name = 'brands_centers_by_rate_personalized'),    
]
