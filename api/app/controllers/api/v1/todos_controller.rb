class Api::V1::TodosController < ApplicationController
    before_action :set_todo, only: [:show, :update, :destroy]

    def index
        todos = Todo.order(created_at: :desc)
        render json: { status: 'SUCCESS', message: 'Loaded todos', data: todos }
    end

    def show
        render json: { status: 'SUCCESS', message: 'Loaded todos', data: @todo }
    end

    def create
        todo = Todo.new(todo_params)
        if todo.save
            render json: { status: 'SUCCESS', data: todo }
        else
            render json: { status: 'ERROR', data: todo.errors }
        end  
    end

    def update
        if @todo.update(todo_params)
            render json: { status: 'SUCCESS', message: 'Updated the todo', data: @todo }
        else  
            render json: { status: 'ERROR', message: 'Not updated', data: @todo.errors }
        end
    end

    def destroy
        @todo.destroy
        render json: { status: 'SUCCESS', message: 'Deleted the todo', data: @todo }
    end

    private

    def set_todo
        @todo = Todo.find(params[:id])        
    end

    def todo_params
        params.require(:todo).permit(:title, :description, :date)
    end
end
