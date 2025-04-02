from django.shortcuts import redirect, render


class LoginRequiredMiddleware:
    """Middleware to restrict access to logged-in users only."""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # These pages don't require login
        allowed_paths = [
            "/logout/", "/faculty/faculty_login/", "/admin/", "/faculty_logout_view/"]

        if not request.session.get("username") and request.path not in allowed_paths:
            # Redirect to login if not authenticated
            return render(request, "superadmin/front_page.html", {"error": "Please log in first."})

        response = self.get_response(request)
        return response
