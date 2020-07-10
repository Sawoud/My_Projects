from django.http import HttpResponse,HttpResponseRedirect
from django.shortcuts import render,redirect,reverse
from .models import Food, UserOrder
from django.contrib.auth.decorators import login_required
from cart.cart import Cart
from . import views
from django.db.models import Sum

import win32api


# Create your views here.
def index(request):
    foods = Food.objects.all()
    if request.user.is_authenticated:
        return HttpResponseRedirect('test')
    else:
        return HttpResponseRedirect('login')
#    return render(request,'orders/pizza_list.html',{'foods':foods})


def test(request):
    foods = Food.objects.all()
    return render(request,'orders/pizza_list.html',{'foods':foods})

def order(request,username,food_id):
    print(food_id)
    print(username)
    O = UserOrder(username = username,Order = Food.objects.all().get(id=food_id))
    O.save()
    print(O.username)
    print(O.Order.id)
#    win32api.MessageBox(0, 'Item Added !', 'Alert')
    return render(request,'orders/done.html')
#    url = reverse('test')
#    return redirect(url)

def show_orders(request,username):
    price = 0
    userorders = UserOrder.objects.all().filter(username = username)
    for userorder in userorders:
        price = price + userorder.Order.price

    return render(request,'orders/orderpage.html',{'userorders':userorders}, {'price':price})

def getrid(request,username,food_id):
    UserOrder.objects.all().filter(username = username).filter(id = food_id).delete()
    userorders = UserOrder.objects.all().filter(username = username)
    for userorder in userorders:
        price = price + userorder.Order.price
    return render(request,'orders/orderpage.html',{'userorders':userorders},{'price':price})
