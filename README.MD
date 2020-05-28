# Red Hat Single Sign On Walkthrough

## Description

This demo showcase a step-by-step guide covering basic capabilities from [Red Hat Single Sign ON](https://access.redhat.com/products/red-hat-single-sign-on) using a simple application js-console.

![](imgs/2020-05-27-15-00-27.png)

js-console and Red Hat SSO running on Openshift.

![](imgs/2020-05-27-14-58-55.png)

## For instructor only

### RHPDS

If you want to use it on RHPDS, create a new Openshift environment using OCP 4.4.

![](imgs/2020-05-27-09-34-46.png)

#### User Projects

```bash
# change this according to the number of expected users
NUMBER_OF_USERS=5

for userNumber in $(seq 1 $NUMBER_OF_USERS); do
  oc adm new-project sso${userNumber} --admin=user${userNumber}
done
```

#### Etherpad

To install etherpad, please check https://github.com/luszczynski/openshift-etherpad

#### Building from Source

Source code artifacts are available in *source* directory. No need to build/compile anything since we're using *JavaScript* and *HTML*.

Docker assets are available in *docker* directory. In order to modify those images, just change *Dockerfile-js-console* or *Dockerfile-rhsso-73* files as needed and execute *docker build -t* from *root* directory . Example:

```bash
  docker build -t rhsso-js-console-app:1.0 -f docker/Dockerfile-js-console .
  docker build -t rhsso73:1.0 -f docker/Dockerfile-rhsso-73 .
```

## For regular users

### Demo Script

0. [Before we begin](#0.-before-we-begin)
1. [Starting RHSSO and JS Console App](#1.-starting-rhsso-and-js-console-app)
2. [Create RHSSO Realm](#2.-create-rhsso-realm)
3. [Create RHSSO Client APP](#3.-create-rhsso-client-app)
4. [Create RHSSO Roles](#4.-create-rhsso-roles)
5. [Create RHSSO User](#5-create-rhsso-user)
6. [Enable SignUp](#6-enable-signup)
7. [Change Themes](#7-change-themes)
8. [User Required Actions](#8-user-required-actions)
9. [Social Login](#9-social-login)
10. [Two Factor with OTP](#10-two-factor-with-otp)
11. [End User Account Management](#11-end-user-account-management)

#### 0. Before we begin

During the labs, you will need the Openshift and Etherpad URL:

* The instructor must provide these URLs

Save the Openshift and Etherpad URL as you are going to need them in the labs.

A number will be assign to your user. On the next labs, everytime you see `userXX` replace `XX` with your number.

#### 1. Starting RHSSO and JS Console App

You can run Red Hat SSO locally or using containers on Openshift. Choose one of the option below.

##### Option 1: Locally

* Execute *docker pull* to download both **Red Hat Single Sign On** and **JS Console:**
  ```
  docker pull viniciusmartinez/rhsso73:1.0
  docker pull luszczynski/sso-console-app:1.0
  ```
* Bootstrap both **Red Hat Single Sign ON** and **JS Console:**

  ```
  docker run -it -p 8080:8080 viniciusmartinez/rhsso73:1.0
  docker run -it -p 80:80 luszczynski/sso-console-app:1.0
  ```
  * if you modify **Red Hat Single Sign On** default port don't forget to update *keycloak.json;*
* Open a browser of your choice and try to access **Red Hat Single Sign On** on the following address with *admin/admin* credentials: http://localhost:8080/auth
* Open a new tab and try to access **JS Console** on the following address: http://localhost:80

##### Option 2: Openshift (Recommended)

First, we need to login on Openshift.

* Username: user`XX` (where XX is your specific number)
* Password: `openshift`

![](imgs/2020-05-27-17-41-42.png)

Make sure you are in the `Developer perspective` and in the namespace sso`XX`.

![](imgs/2020-05-27-17-43-31.png)

###### Deploy SSO

* Click on `+Add` -> `From Catalog`
![](imgs/2020-05-27-17-45-54.png)
* Search for `sso` in the filter field and select `Red Hat Single Sign-On 7.3 (Ephemeral)`
![](imgs/2020-05-27-17-55-58.png)
* Click on `Instantiatee Template`
![](imgs/2020-05-27-17-56-28.png)
* Leave the fields as they are and just change both `RH-SSO Administrator Username` and `RH-SSO Administrator Password` to `admin`
![](imgs/2020-05-27-17-57-10.png)
* Wait while Openshift pull the necessary images for Red Hat SSO. When it has finished, you'll see the following screen
![](imgs/2020-05-27-17-58-50.png)

###### Deploy js-console

* On the left menu, click on `+Add` -> `Container Image`
![](imgs/2020-05-27-18-00-20.png)
* Use `docker.io/luszczynski/rhsso-js-console-app:1.0` in the `Image name from external registry` field
* Application Name: `redhat-sso`
* Name: `js-console`
![](imgs/2020-05-27-18-03-23.png)
* Now click on `Create`
* Click on the SSO circle and then on the resources tab, copy the Route URL
![](imgs/2020-05-27-18-07-42.png)
* Open the js-console Deployment by clicking on `js-console`
![](imgs/2020-05-27-18-09-38.png)
* Now select the `Environment` tab and create a new env `AUTH_SERVER_URL` and fill the value field with the content of the URL of SSO. In the end of the SSO URL, add `/auth`. Now click on `Save`
![](imgs/2020-05-27-18-12-51.png)
* Switch back to the topology view and Open the js-console app by clicking on the icon
![](imgs/2020-05-27-18-14-57.png)

###### Grouping js-console and SSO

* While holding down `Shift`, drag the SSO circle near to the js-console
![](imgs/May-27-2020-18-15-58.gif)
* Now create a connection between js-console and sso by pulling an arrow from js-console towards sso circle
![](imgs/May-27-2020-18-20-04.gif)

###### Using the CLI

All steps that were executed above, could be done using the following commands

WARN: You should execute the commands below only if you skipped all steps from [lab 1](#1-starting-rhsso-and-js-console-app)

```bash
userNumber=1

oc new-app \
    --template=sso73-x509-https \
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

  oc expose svc js-console -n sso${userNumber}

  oc label dc js-console app.kubernetes.io/part-of="redhat-sso" -n sso${userNumber}
  oc label dc sso app.kubernetes.io/part-of="redhat-sso" -n sso${userNumber}
  oc annotate svc js-console app.openshift.io/connects-to=sso73-x509-https -n sso${userNumber}
  oc annotate dc js-console app.openshift.io/connects-to=sso73-x509-https -n sso${userNumber}
```

#### 2. Create RHSSO Realm

##### Intro do Realms

A realm manages a set of users, credentials, roles, and groups. A user belongs to and logs into a realm. Realms are isolated from one another and can only manage and authenticate the users that they control.

When you boot Red Hat Single Sign-On for the first time Red Hat Single Sign-On creates a pre-defined realm for you. This initial realm is the master realm. It is the highest level in the hierarchy of realms. Admin accounts in this realm have permissions to view and manage any other realm created on the server instance. When you define your initial admin account, you create an account in the master realm. Your initial login to the admin console will also be via the master realm.

We recommend that you do not use the master realm to manage the users and applications in your organization. Reserve use of the master realm for super admins to create and manage the realms in your system. Following this security model helps prevent accidental changes and follows the tradition of permitting user accounts access to only those privileges and powers necessary for the successful completion of their current task.

* From now on, save the SSO URL. You will use it in all labs. To find this URL, click on the `Open URL` icon
![](imgs/2020-05-28-07-50-20.png)
* Repeat the step above to `js-console` application. You will also need this URL for the next labs.
![](imgs/2020-05-28-07-53-33.png)
* Go to the **Red Hat Single Sign On** browser tab and place the mouse on the left top corner, right above the *Master*. Click on the arrow button and select **Add Realm**
![](imgs/2020-05-27-15-15-17.png)
* In the *name* textfield use: *demo*
* Click on *Create* button
![](imgs/2020-05-27-15-15-58.png)

##### Realm Reference

* https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#the_master_realm
* https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#create-realm

#### 3. Create RHSSO Client App

##### Intro to Client

Clients are entities that can request Red Hat Single Sign-On to authenticate a user. Most often, clients are applications and services that want to use Red Hat Single Sign-On to secure themselves and provide a single sign-on solution. Clients can also be entities that just want to request identity information or an access token so that they can securely invoke other services on the network that are secured by Red Hat Single Sign-On.

* Click on *Clients* right bellow the *Realm Settings* at the left menu
* Click on *Create* button on the right corner
![](imgs/2020-05-27-15-17-10.png)
* On the *Client ID* textfield, use: *js-console*
* Inform the *Root URL*: Paste the URL from **js-console** that you generate on [Lab 2](#2-create-rhsso-realm)
* Click on **Save** button
![](imgs/2020-05-27-15-27-09.png)

##### Client Reference

* https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#clients

#### 4. Create RHSSO Roles

##### Intro do Roles

Roles identify a type or category of user. Admin, user, manager, and employee are all typical roles that may exist in an organization. Applications often assign access and permissions to specific roles rather than individual users as dealing with users can be too fine grained and hard to manage.

* Click on **Roles** right bellow the **Client Templates** at the left menu;
* Click on *Add Role* button
![](imgs/2020-05-27-15-29-33.png)
* For the *Role Name* inform `realm-role` as value and click on **Save** button afterward
![](imgs/2020-05-27-15-30-31.png)
* Click on **Clients** right bellow the **Realm Settings** at the left menu
* Select **js-console** and **Roles** afterward
![](imgs/2020-05-27-15-31-30.png)
![](imgs/2020-05-27-15-32-00.png)
* Click on **Add Role** button
![](imgs/2020-05-27-15-32-32.png)
* For the *Role Name* inform `client-role` and afterwards **Save** button
![](imgs/2020-05-27-15-33-05.png)
* Click on **Roles** again;
* Select *Default Roles;*
![](imgs/2020-05-27-15-33-49.png)
* Select `realm-role` from *Available Roles* list and click on **Add Selected**
![](imgs/2020-05-27-15-34-38.png)
* In the *Client Roles* select **js-console** and click on **Add Selected**
![](imgs/2020-05-27-15-35-42.png)

##### Roles Reference

* https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#roles

#### 5. Create RHSSO User

##### Intro to Users

Users are entities that are able to log into your system. They can have attributes associated with themselves like email, username, address, phone number, and birth day. They can be assigned group membership and have specific roles assigned to them.

* Click on **Users** right bellow the **Groups** at the left menu;
* Click on *Add User* button;
![](imgs/2020-05-27-15-36-57.png)
* Inform the *Username* `myuser` and click on **Save** button;
![](imgs/2020-05-27-15-38-27.png)
* Go to *Credentials* tab and inform the password `mypass`;
* Change *Temporary* to **OFF**;
* Finally click on **Reset Password**;
![](imgs/2020-05-27-15-39-36.png)
* Switch back to **JS Console** tab and click on **Login**
![](imgs/2020-05-27-15-41-32.png)
* The **Red Hat Single Sign On** login page will be displayed. Inform the credentials from the user you've created on previous step;
  * user: `myuser`
  * pass: `mypass`
![](imgs/2020-05-27-15-42-49.png)
* If everything is properly configured, after a successfully login you will be redirected to the **JS Console App**. Please notice the **Init Success (Authenticated)** right below the *Result* label;
![](imgs/2020-05-27-15-43-31.png)
* Considering exploring all buttons (Get Profile, Get User Info, Show Token) to familiarize yourself with *OpenID/OAuth* standards;

##### Users Reference

* https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#user_management

#### 6. Enable SignUp

##### Intro to Authentication Flows

Authentication flows are work flows a user must perform when interacting with certain aspects of the system. A login flow can define what credential types are required. A registration flow defines what profile information a user must enter and whether something like reCAPTCHA must be used to filter out bots. Credential reset flow defines what actions a user must do before they can reset their password.

* Go back to **JS Console** browser tab and click on **Logout**
![](imgs/2020-05-27-15-44-40.png)
* Switch back to **Red Hat Single Sign On** and click on **Realm Settings** right bellow the **Realm Name (Demo)** and select *Login;*
* Enable *User Registration*
* Click on **Save**
![](imgs/2020-05-27-15-46-25.png)
* On **JS Console** browser tab click on **Login** button;
![](imgs/2020-05-27-15-41-32.png)
* Click on **Register** and create a new user informing all required fields;
![](imgs/2020-05-27-15-48-00.png)
![](imgs/2020-05-27-15-49-00.png)
* if you experience session issues with other users, considering open a new browser instance or an incognito tab;

##### Authentication Reference

* https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#authentication-flows

#### 7. Change Themes

##### Intro to Themes

Every screen provided by Red Hat Single Sign-On is backed by a theme. Themes define HTML templates and stylesheets which you can override as needed.

* Go to **JS Console** browser tab and click on **Logout;**
![](imgs/2020-05-27-15-44-40.png)
* On **Red Hat Single Sign On** browser tab, click **Realm Settings** and select **Themes** tab;
* Select theme `keycloak` from **Login Theme** dropdown list;
* Click on **Save;**
![](imgs/2020-05-27-15-54-25.png)
* Go back to **JS Console** browser tab and click on **Login;**
![](imgs/2020-05-27-15-41-32.png)
* Notice  a different look'n'feel from **Red Hat Single Sign On** login page;
![](imgs/2020-05-27-15-54-49.png)

##### Themes Reference

* https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#themes

#### 8. User Required Actions

##### Intro to Required Actions

Required Actions are tasks that a user must finish before they are allowed to log in. A user must provide their credentials before required actions are executed. Once a required action is completed, the user will not have to perform the action again.

* Click on **Users** right bellow the **Groups** at the left menu;
* Click on *View all users* button and select one;
* Select an user by clicking on *Edit*;
![](imgs/2020-05-27-16-47-02.png)
* Select `Update Password` action on **Required User Actions** menu;
* Click on **Save**
![](imgs/2020-05-27-16-49-28.png)
* Try to login with this user and now you'll have to execute the *Required Actions* previously configured;
![](imgs/2020-05-27-16-50-18.png)

##### Required Actions Reference

* https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#required_actions

#### 9. Social Login

##### Intro to Social Login

Enable login with Google, GitHub, Facebook, Twitter, and other social networks.

* Go to **JS Console** browser tab and click on **Logout;**
![](imgs/2020-05-27-15-44-40.png)
* On **Red Hat Single Sign On** browser tab, click on **Identity Providers** right bellow the **Roles** at the left menu;
* Select *Github*;
![](imgs/2020-05-27-16-59-14.png)
* Now copy the redirect URI
![](imgs/2020-05-27-17-00-24.png)
* Open a new tab and access your *Github* account.
  * Select **Settings** 
![](imgs/2020-05-27-17-02-53.png)
  * Now go to **Developer Settings** 
![](imgs/2020-05-27-17-04-55.png)
  * Select **OAuth Apps** and finally click on: **Register a new application**
![](imgs/2020-05-27-17-05-58.png)
* For *Application name* use `sso`
* *Homepage URL* use `http://localhost`
* *Redirect URI* Copy from **Red Hat Single Sign On** browser tab and paste it on **CallBack URL**
* Click on **Register Application**
![](imgs/2020-05-27-17-09-12.png)
* Copy both **Client ID** and **Client Secret** from *Github* and paste them on *RHSSO*
![](imgs/2020-05-27-17-10-55.png)
![](imgs/2020-05-27-17-12-23.png)
* Click on **Save**
* Go back to **JS Console** browser tab and click on **Login;**
![](imgs/2020-05-27-15-41-32.png)
* Notice that now you have the option to login with *Github*;
![](imgs/2020-05-27-17-13-13.png)
![](imgs/2020-05-27-17-13-37.png)

##### Social Login Reference

* https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#identity_broker

#### 10. Two-Factor with OTP

##### Intro to OTP

Red Hat Single Sign-On has a number of policies you can set up for your FreeOTP or Google Authenticator One-Time Password generator. When configuring OTP, FreeOTP and Google Authenticator can scan a QR code that is generated on the OTP set up page that Red Hat Single Sign-On has. 

There are two different algorithms to choose from for your OTP generators. Time Based (TOTP) and Counter Based (HOTP). For TOTP, your token generator will hash the current time and a shared secret. The server validates the OTP by comparing all the hashes within a certain window of time to the submitted value. So, TOTPs are valid only for a short window of time (usually 30 seconds). For HOTP a shared counter is used instead of the current time. The server increments the counter with each successful OTP login. So, valid OTPs only change after a successful login.

* On **JS Console** browser tab, click on **Logout;**
![](imgs/2020-05-27-15-44-40.png)
* On **Red Hat Single Sign On** browser tab, click on **Authentication** right bellow the **User Federation** at the left menu;
* Change the default *OTP FORM* from **OPTIONAL** to **REQUIRED**;
![](imgs/2020-05-27-17-22-05.png)
* Go back to **JS Console App (http://localhost:80)** and click on **Login;**
![](imgs/2020-05-27-15-41-32.png)
  * Consider installing *FreeOTP* or *Google Authenticator* and configure the authentication by scanning the provided *QR Code*;
![](imgs/2020-05-27-17-24-02.png)

##### OTP Reference

* https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#otp_policies

#### 11. End User Account Management

##### Intro to Account Management

Red Hat Single Sign-On has a built-in User Account Service which every user has access to. This service allows users to manage their account, change their credentials, update their profile, and view their login sessions. The URL to this service is <server-root>/auth/realms/{realm-name}/account.

* On **Red Hat Single Sign On** browser tab, click on **Clients** right bellow the **Realm Settings** at the left menu;
* Now click on the Account Base URL link
![](imgs/2020-05-27-17-30-08.png)
* Navigate through the options and update your profile if desired;

##### Account Management Reference

* https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#account-service
