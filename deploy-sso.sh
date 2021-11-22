userNumber=1
oc new-project sso${userNumber}

oc new-app \
    --template=sso73-ocp4-x509-https \
    -p APPLICATION_NAME=sso \
    -p SSO_ADMIN_USERNAME=admin \
    -p SSO_ADMIN_PASSWORD=admin \
    -n sso${userNumber}

  ROUTE_PATH=https://$(oc get --no-headers route sso -o jsonpath='{.spec.host}' -n sso${userNumber})/auth

  oc new-app \
    docker.io/luszczynski/rhsso-js-console-app:1.0 \
    AUTH_SERVER_URL=$ROUTE_PATH \
    --name=js-console \
    -n sso${userNumber}

  oc new-app \
    mailhog/mailhog \
    --name=mailhog \
    -n sso${userNumber}

  oc expose svc js-console -n sso${userNumber}
  # oc expose svc mailhog --target-port=8025-tcp -port 8025 -n sso${userNumber}
  oc expose svc mailhog --target-port=8025-tcp -n sso${userNumber}

  oc label deploy js-console app.kubernetes.io/part-of="redhat-sso" -n sso${userNumber}
  oc label dc sso app.kubernetes.io/part-of="redhat-sso" -n sso${userNumber}
  oc label deploy mailhog app.kubernetes.io/part-of="redhat-sso" -n sso${userNumber}
  oc annotate deploy js-console app.openshift.io/connects-to=sso73-ocp4-x509-https -n sso${userNumber}
  oc annotate dc sso app.openshift.io/connects-to=mailhog -n sso${userNumber}