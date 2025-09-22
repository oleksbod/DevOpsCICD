from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('health/', views.health, name='health'),
    path('api/login/', views.api_login, name='api_login'),
    path('api/logout/', views.api_logout, name='api_logout'),
    path('api/posts/', views.api_posts, name='api_posts'),
    path('api/posts/create/', views.api_create_post, name='api_create_post'),
]
