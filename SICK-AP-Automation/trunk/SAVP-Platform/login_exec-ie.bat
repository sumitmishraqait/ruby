cucumber features/login.feature --tags ~@fail --tags ~@featureNotDevYet --tags ~@IE11fail BROWSER=ie -f html -o reports/IE11/results_login_ie-%date:~10,4%%date:~7,2%%date:~4,2%_%time:~1,1%%time:~3,2%.html