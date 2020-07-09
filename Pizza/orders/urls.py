from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("test/", views.test, name="test"),
    path("test/<username>/<int:food_id>/", views.order, name="order"),
    path("show_orders/<username>/", views.show_orders, name="show_orders"),
    path("getrid/<username>/<int:food_id>/", views.getrid, name="getrid"),

]
