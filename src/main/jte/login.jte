@param String error = null
@param String logout = null
@param org.springframework.security.web.csrf.CsrfToken _csrf

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Madania Therapy Center</title>
</head>
<body>
<h2>Sign in</h2>

@if(error != null)
    <p>Invalid username or password.</p>
@endif

@if(logout != null)
    <p>You have been logged out.</p>
@endif

<form action="/login" method="post">
    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
    <div>
        <label>Username</label>
        <input type="text" name="username" required>
    </div>
    <div>
        <label>Password</label>
        <input type="password" name="password" required>
    </div>
    <button type="submit">Sign in</button>
</form>
</body>
</html>