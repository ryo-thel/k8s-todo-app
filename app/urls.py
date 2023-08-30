from django.urls import path
from . import views

urlpatterns = [
    path('', views.todo_list, name='todo_list'),
    path('edit/<int:id>/', views.edit_todo, name='edit_todo'),
]
