from django.shortcuts import render, redirect, get_object_or_404
from .models import Todo
from .forms import TodoForm

def todo_list(request):
    todos = Todo.objects.all()
    if request.method == "POST":
        form = TodoForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('todo_list')
    else:
        form = TodoForm()
    return render(request, 'todo_list.html', {'todos': todos, 'form': form})

def edit_todo(request, id):
    instance = get_object_or_404(Todo, id=id)
    form = TodoForm(request.POST or None, instance=instance)
    if form.is_valid():
        form.save()
        return redirect('todo_list')
    return render(request, 'edit_todo.html', {'form': form})
