from django.shortcuts import redirect, render


class LoginRequiredMiddleware:
    """Middleware to restrict access to logged-in users only."""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # These pages don't require login
        allowed_paths = ["/student/login/", "/admin/", "/add_coordinator/", "/",
                         "/login_view/", "/faculty_logout_view/"]

        # Check if the user is logged in as a coordinator or faculty
        if not request.session.get("username") and not request.session.get("faculty_id") and request.path not in allowed_paths:
            # Redirect to login if not authenticated
            return render(request, "superadmin/login.html", {"error": "Please log in first."})

        response = self.get_response(request)
        return response


# from django.shortcuts import redirect
# from django.urls import reverse


# class LoginRequiredMiddleware:
#     """Middleware to restrict access to logged-in users only."""

#     def __init__(self, get_response):
#         self.get_response = get_response

#     def __call__(self, request):
#         # Skip the login check for paths like login or logout view to avoid redirect loops
#         # Modify these conditions based on your own login and logout view paths
#         if not request.user.is_authenticated:
#             # Redirect to the login page if the user is not authenticated
#             # Ensure we don't redirect if the user is already at the login/logout page
#             if not (request.path.startswith(reverse('login_view')) or request.path.startswith(reverse('faculty_logout_view'))):
#                 # Redirect to your login page URL (adjust the name as necessary)
#                 return redirect('login_view')

#         # Continue with the request if the user is authenticated or the path does not require authentication
#         response = self.get_response(request)
#         return response
