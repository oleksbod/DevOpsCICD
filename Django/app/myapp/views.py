from django.shortcuts import render
from django.http import JsonResponse
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.db import connection
import json
import time


def home(request):
    """Головна сторінка"""
    return render(request, 'myapp/home.html', {
        'title': 'Django App - Final Project',
        'message': 'Welcome to Django App with Prometheus monitoring!'
    })


def health(request):
    """Health check endpoint"""
    return JsonResponse({
        'status': 'healthy',
        'timestamp': time.time(),
        'database': check_database_connection()
    })


def check_database_connection():
    """Перевірка підключення до бази даних"""
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
        return 'connected'
    except Exception as e:
        return f'error: {str(e)}'


@csrf_exempt
@require_http_methods(["POST"])
def api_login(request):
    """API endpoint для логіну"""
    try:
        data = json.loads(request.body)
        username = data.get('username')
        password = data.get('password')
        
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return JsonResponse({'status': 'success', 'message': 'Logged in successfully'})
        else:
            return JsonResponse({'status': 'error', 'message': 'Invalid credentials'}, status=401)
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=400)


@csrf_exempt
@require_http_methods(["POST"])
def api_logout(request):
    """API endpoint для логауту"""
    logout(request)
    return JsonResponse({'status': 'success', 'message': 'Logged out successfully'})


@login_required
def api_posts(request):
    """API endpoint для отримання постів"""
    from .models import Post
    posts = Post.objects.all()[:10]  # Останні 10 постів
    return JsonResponse({
        'posts': [
            {
                'id': post.id,
                'title': post.title,
                'content': post.content,
                'author': post.author.username,
                'created_at': post.created_at.isoformat()
            }
            for post in posts
        ]
    })


@csrf_exempt
@require_http_methods(["POST"])
@login_required
def api_create_post(request):
    """API endpoint для створення поста"""
    try:
        data = json.loads(request.body)
        from .models import Post
        
        post = Post.objects.create(
            title=data.get('title'),
            content=data.get('content'),
            author=request.user
        )
        
        return JsonResponse({
            'status': 'success',
            'post_id': post.id,
            'message': 'Post created successfully'
        })
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=400)
