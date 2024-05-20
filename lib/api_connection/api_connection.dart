class API{
  static const hostConnect="http://192.168.1.104/api_gettogether" ;
  static const hostConnectUser="http://192.168.1.104/api_gettogether/user" ;

  //signup user
  static const validateEmail="$hostConnect/user/validate_email.php";
  static const signup="$hostConnect/user/signup.php";
  static const login="$hostConnect/user/login.php";
  static const createActivity="$hostConnect/activity/createactivity.php";
  static const showActivity="$hostConnect/activity/showActivity.php";
  static const timeActivity="$hostConnect/activity/timeActivity.php";
  static const order="$hostConnect/activity/order.php";
  static const joinedActivity="$hostConnect/user/joined_activity.php";
  static const currentPlus="$hostConnect/activity/currentPlus.php";
}