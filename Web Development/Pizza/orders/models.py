from django.db import models


class Food(models.Model):
    type_of_food = models.CharField(max_length=10)
    style = models.CharField(max_length=30)
    size = models.CharField(max_length=10,null=True)
    TOPPINGS_NUMBER = [("None","None"), ("1","1"),("2","2"),("3","3")]
    toppingsNum = models.CharField(max_length = 5, choices = TOPPINGS_NUMBER,default = "None")

    topping1 = models.CharField(max_length=30, blank = True)
    topping2 = models.CharField(max_length=30, blank = True)
    topping3 = models.CharField(max_length=30, blank = True)

    price = models.FloatField()



class UserOrder(models.Model):
    username = models.CharField(max_length=100)
    Order = models.ForeignKey(Food, on_delete=models.CASCADE)



# class Pizza(models.Model):
#
#     size = models.CharField(max_length=10)
#
#
#     pizza = models.CharField(max_length=20)
#
#
#     style = models.CharField(max_length=30)
#
#     TOPPINGS_NUMBER = [("None","None"), ("1","1"),("2","2"),("3","3")]
#     toppingsNum = models.CharField(max_length = 5, choices = TOPPINGS_NUMBER,default = "None")
#
#     topping1 = models.CharField(max_length=30, blank = True)
#     topping2 = models.CharField(max_length=30, blank = True)
#     topping3 = models.CharField(max_length=30, blank = True)
#
#     price = models.FloatField()
#
#
# class Subs (models.Model):
#
#     size = models.CharField(max_length=5)
#
#
#     style = models.CharField(max_length=20)
#
#     ADD_ONS = (
#         ('M', 'Mushrooms'),
#         ('G', 'Green Peppers'),
#         ('O', 'Onions'),
#         ('C', 'Cheese'),
#     )
#     addons = models.CharField(max_length=1)
#
#     price = models.FloatField()
#
#
#
# class Pasta (models.Model):
#     PASTA_STYLE = (
#         ('Z', 'Baked Ziti w/Mozzarella'),
#         ('M', 'Baked Ziti w/Meatballs'),
#         ('C', 'Baked Ziti w/Chicken'),
#
#     )
#     style = models.CharField(max_length=2, choices=PASTA_STYLE)
#
#     price = models.FloatField()
#
#
# class Salads (models.Model):
#     SALAD_STYLE = (
#         ('G', 'Garden Salad'),
#         ('E', 'Greek Salad'),
#         ('A', 'Antipasto'),
#         ('T', 'Salad w/Tuna'),
#
#     )
#     style = models.CharField(max_length=2, choices=SALAD_STYLE)
#
#     price = models.FloatField()
#
# class Platters (models.Model):
#     SIZE = (
#         ('S', 'Small'),
#         ('L', 'Large'),
#     )
#     size = models.CharField(max_length=1, choices=SIZE)
#
#     PLATTER_STYLE = (
#         ('G', 'Garden Salad'),
#         ('E', 'Greek Salad'),
#         ('A', 'Antipasto'),
#         ('Z', 'Baked Ziti'),
#         ('M', 'Meatball Parm'),
#         ('C', 'Chicken Parm'),
#
#     )
#     style = models.CharField(max_length=2, choices=PLATTER_STYLE)
#     price = models.FloatField()
#
# class Product(models.Model):
#     type = models.CharField(max_length = 20)
#     name = models.CharField(max_length=255)
#     price = models.FloatField()
