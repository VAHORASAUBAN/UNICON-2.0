from django.shortcuts import redirect, render


class LoginRequiredMiddleware:
    """Middleware to restrict access to logged-in users only."""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # These pages don't require login
        allowed_paths = ["/student/login/", "/admin/",
                         "/login_view/", "/faculty_logout_view/",
                         "/add_coordinator/"]

        if not request.session.get("username") and request.path not in allowed_paths:
            # Redirect to login if not authenticated
            return render(request, "superadmin/login.html", {"error": "Please log in first."})

        response = self.get_response(request)
        return response
