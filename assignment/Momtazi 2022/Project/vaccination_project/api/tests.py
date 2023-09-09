from rest_framework.test import APIRequestFactory
from rest_framework.test import APITestCase, APIClient
from django.test import TestCase


class NursesTestCase(TestCase):

    def setUp(self):
        self.factory = APIRequestFactory()
        self.client = APIClient()
        self.factory.post('register', {
            'username': '0123456789',
            'first_name': 'Keivan',
            'last_name': 'Ipchi Hagh',
            'gender': 1,
            'birth_date': '2001-04-01',
            'sickness_history': 0,
            'password': '1234'
        })
        self.client.post('register', {
            'username': '1234567890',
            'first_name': 'John',
            'last_name': 'Doe',
            'gender': 1,
            'birth_date': '2011-05-11',
            'sickness_history': 1,
            'password': '4321'
        })
        self.client.post('register', {
            'username': '2345678901',
            'first_name': 'Jane',
            'last_name': 'Doe',
            'gender': 0,
            'birth_date': '2021-12-23',
            'sickness_history': 0,
            'password': '1111'
        })
        self.client.post('register', {
            'username': '3456789012',
            'first_name': 'Kristen',
            'last_name': 'Stewart',
            'gender': 0,
            'birth_date': '1998-06-16',
            'sickness_history': 1,
            'password': '2222'
        })
    
    def test_register_nurse(self):
        self.assertEqual(self.factory.post('register_nurse', {
            'username': '0123456789',
            'code': '12345678',
            'type': 'nurse'
            }), '{"Response": "Success"}')