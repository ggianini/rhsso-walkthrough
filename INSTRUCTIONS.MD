<p align="center">
    <img alt="Logo OpenShift" height="100" src="docs/images/logo.png">
</p>

<h1 align="center">
    Demo Guide - RHSSO
</h1>

<h2 align="center">
    Single-Sign On
</h2>

<p align="center">
    <img alt="Made By" src="https://img.shields.io/badge/Made%20By-Hugo%20Pfeffer-blueviolet?style=for-the-badge&logo=appveyor">
    <img alt="Made By" src="https://img.shields.io/badge/Made%20By-Gustavo%20Gianini-blueviolet?style=for-the-badge&logo=appveyor">
    <img alt="Made By" src="https://img.shields.io/badge/License-GPL%203.0-blue?style=for-the-badge">
</p>
<br>


# Deploying

## Index
* [0. Getting Started](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/getting-started.adoc)
* [1. Creating and starting RHSSO and js-console App](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/starting-rhsso-and-js-console.adoc)
* [2. Create RHSSO Realm](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/create-rhsso-realm.adoc)
* [3. Configuring Email](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/configuring-email.adoc)
* [4. Create RHSSO Client App](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/create-rhsso-client-app.adoc)
* [5. Create RHSSO Roles](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/create-rhsso-roles.adoc)
* [6. Create RHSSO User](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/create-rhsso-user.adoc)
* [7. Enable SignUp](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/enable-signup.adoc)
* [8. User Federation](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/user-federation.adoc)
* [9. Change Themes](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/change-themes.adoc)
* [10. User Required Actions](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/user-required-actions.adoc)
* [11. Social Login](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/social-login.adoc)
* [12. Two-Factor With OTP](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/two-factor-with-otp.adoc)
* [13. Account Management](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/end-user-account-management.adoc)
* [14. Auditing and Events](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/auditing-events.adoc)


# Script
### <i>`Note: It is expected that you have followed all the deploying steps listed on Index`</i>

</br>

## Signup
* Show the user registration 
* Show the confirmation email sent to a mock email previously set up 
* Logout and Log back in with the newly created user

## User Federation
* Talk about how LDAP can be implemented to store and manage user and credential information

## Change Themes
* Change the Login themes, it can be changed to whatever theme they want, but by default there's only 3.

[<i>*Themes Reference</i>](https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#themes)


## Required Actions

* Show the required actions functions on the administrative Dashboard, on Users.
* Logout
* Login with the same password
* Show the message

[<i>*Required Actions Reference</i>](https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#required_actions)

## Social Login

* After the proper configuration shown on [11. Social Login](https://github.com/HugoPfeffer/rhsso-walkthrough/tree/master/docs/social-login.adoc)
* Show the Login being done throught GitHub

[<i>*Social Login Reference</i>](https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#identity_broker)


## Two-Factor With OTP

* Show the authetication throught FreeOTP or Google Auth
* Fail the login to show that it works
* Login with the correct code

[<i>*OTP Reference</i>](https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#otp_policies)

## Account Management

* Explain that Red Hat Single Sign-On has a built-in User Account Service which every user has access to and every user has accsess to it for the management of their account
* The URL to this service is <server-root>/auth/realms/{realm-name}/account.
* Show the options available.

[<i>*Account Management Reference</i>](https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#account-service)

<!-- ## Auditing and Events

* 

[<i>*Themes Reference</i>](https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#themes)

[<i>*Themes Reference</i>](https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html-single/server_administration_guide/index#themes) -->

