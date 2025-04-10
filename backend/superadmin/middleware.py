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
