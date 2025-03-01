from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from addcoordinator import views
urlpatterns = [
    path('add_coordinator/', views.add_coordinator, name='add_coordinator'),
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)