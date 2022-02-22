import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PrayerType {
  answered,
  myPrayers,
  group,
  global,
}

class Constants {
  static final ppcMainGradient = [
    Colors.lightBlue.shade200,
    Colors.lightBlueAccent.shade200,
  ];
}

class UserData {
  static final String userUID = FirebaseAuth.instance.currentUser!.uid;
  static final avatar =
      FirebaseStorage.instance.ref().child(userUID).getDownloadURL() as String;
}

class Globals {
  static String prayerListName = 'My Prayers'; // may not need
  static String uid = '';
  static String userName = 'User Name';
  static DateFormat formatDate = DateFormat("yMd");
  static var numberFormat = NumberFormat("###,###");
}

class PPCstuff {
  static const divider =
      Divider(height: 10, thickness: 1, indent: 20, endIndent: 20);
  static const smallTextStyle = TextStyle(
    fontFamily: 'Helvetica',
    color: Colors.black,
    fontSize: 16,
    height: 1.8,
  );
}

class ImagesURLConstants {
  static const ppcLogo = 'assets/images/PrayerPalsLogo.png';
}

class StringConstants {
//App
  static const prayerPals = 'Prayer Pals';
//Assets
  static const groupIcon = 'assets/images/group_icon.jpeg';
  static const userIcon = 'assets/images/user_icon.jpeg';
//Login and Registration
  static const forgotPassword = 'Forget Password?';
  static const areYouSure = 'Are You Sure?';
  static const doYouWishToDeleteThisPrayer =
      'Delete this prayer?\nThis cannot be undone.';
  static const createAnAccountCaps = 'CREATE AN ACCOUNT';
  static const emailAddress = 'Email Address';
  static const loginCaps = 'LOGIN';
  static const newToPrayerPals = 'New To Prayer Pals?';
  static const password = 'Password';
  static const pleaseClickVerificationLinkMsg =
      'Please click the verification link in the email to activate your account.\n\nYou may then sign in.';
  static const pleaseEnterAnEmailAddress =
      'Please enter a valid email address and we will send you a reset password link';
  static const verificationEmailMsg1 = 'We have sent an email to: ';
  static const aPasswordResetEmailWasSent =
      'A password reset link was sent to your email address!';
  static const signUpCaps = 'SIGN UP';
  static const username = 'Username';
  static const register = 'Register';
  static const welcome = 'Welcome';
  static const loading = 'Loading ...';
  static const purchaseSuccessful = 'Thank you.\nYour purchase was successful';

//Page Titles
  static const addPrayer = 'Add Prayer';
  static const editPrayer = 'Edit Prayer';
  static const editAnsweredPrayer = 'Edit Answered Prayer';
  static const addToMyPrayers = 'Add To My Prayers';
  static const prayers = 'Prayers';
  static const answeredPrayer = 'Answered Prayer';
  static const prayNow = 'Pray Now';
  static const activity = 'Activity';
  static const connections = 'Connections';
  static const settings = 'Settings';
  static const home = 'Home';
  static const myPrayers = 'My Prayers';
  static const myGroups = 'My Groups';
  static const joinGroup = 'Join Group';
  static const leaveGroup = 'Leave Group';
  static const startGroup = 'Start Group';
  static const admin = 'Admin';
  static const adminContacts = 'Contacts';
  static const members = 'Members';
  static const editProfile = 'Edit Profile';
  static const answered = 'Answered';

//Prayers
  static const almostThere = 'Almost There...';
  static const createPrayerErrorNoTitle = '- Please enter a title';
  static const createPrayerErrorNoDescription = '- Please enter a description';

  static const createGroupMembersErrorNoTitle = '- Please enter a title';
  static const createGroupMembersErrorNoDescription =
      '- Please enter a description';
  static const details = 'Details...';
  static const done = 'Done';
  static const edit = 'Edit';
  static const saveChanges = 'Save Changes';
  static const view = 'View';
  static const prayerTitle = 'Prayer Title';
  static const remove = 'Remove';
  static const add = 'Add';
  static const global = 'global';
  static const lowercaseAnswered = 'answered';
  static const hoursPrayer = 'hoursPrayer';

//Collections
  static const usersCollection = 'users';
  static const myPrayersCollection = 'myPrayers';
  static const answeredPrayersCollection = 'answeredPrayers';
  static const userGroupsCollection = 'userGroups';
  static const globalPrayersCollection = 'globalPrayers';
  static const globalAnsweredCollection = 'globalAnswered';
  static const groupsCollection = 'groups';
  static const groupMemberCollection = "groupMember";
  static const groupPrayerCollection = "groupPrayers";
  static const groupAnsweredCollection = "groupAnswered";
  static const scriptureCollection = 'scriptures';
  static const groupImageURL = 'groupImageURL';
  static const myGroupsCollection = 'myGroups';
  static const pendingRequestsCollection = 'pendingRequests';
  static const subscribedGroups = 'subscribedGroups';
  static const reportedPrayersCollection = 'reportedPrayers';

//Params
  static const memberCount = 'memberCount';
  static const prayerCount = 'prayerCount';
  static const reportCount = 'reportCount';
  static const reportedBy = 'reportedBy';
  static const groupCreationCredits = 'groupCreationCredits';
  static const removeAdsParam = 'removedAds';

//Messages
  static const genericError = 'Generic Error';
  static const okCaps = 'OK';
  static const oops = 'Oops';
  static const success = 'Success';
  static const unknownError =
      'Sorry! An unknown error occurred.\nPlease try again later';
  static const couldNotLaunch = 'Could not launch ';
  static const areYouSureYouWishToCancelThisReminder =
      'Are you sure you wish to cancel this reminder?';
  static const areYouSureYouWishToDeleteThisGroup =
      'Are you sure you wish to delete this group?';
  static const areYouSureYouWishToLeaveThisGroup =
      'Are you sure you wish to leave this group?';
  static const areYouSureYouWishToDisableAllNotifications =
      'Are you sure you wish to disable all notifications';
  static const areYouSureYouWishToDeleteThisMember =
      'Are you sure you wish to delete this group member?';
  static const prayerReported =
      'This prayer has been reported and submitted for review.\n\nThank you for your feedback.';
  static const reporthingThisPrayer =
      'Reporting this prayer will remove it from the app and send it to the review process. If it is found to be in violation of our Terms of Use, the prayer will be removed and the user may be permanently blocked.\n\nAre you sure you want to report this prayer?';
  static const areYouSureYouWishToDeleteYourPrayer =
      'Are you sure you wish to delete your prayer?';
  static const areYouSureYouWishToRemoveThisGlobalPrayerFromYourPrayerList =
      'Are you sure you wish to remove this global prayer from your prayer list?';
//Activity
  static const memberSince = 'Member Since';
  static const answeredPrayers = 'Answered Prayers';
  static const prayersRequested = 'Prayers Requested';
  static const hoursInPrayer = 'Hours in Prayer';
  static const daysPrayedWeek = 'Days Prayed This Week';
  static const daysPrayedMonth = 'Days Prayed This Month';
  static const daysPrayedYear = 'Days Prayed This Year';
  static const daysPrayedLastYear = 'Days Prayed Last Year';

// Settings Page
  static const settingsCaps = 'SETTINGS';
  static const changePassword = 'Change Password';
  static const setReminder = 'Set Daily Prayer Reminder';
  static const cancelReminder = 'Cancel Daily Prayer Reminder';
  static const viewActivity = 'View Activity';
  static const notifications = 'Notifications';
  static const notificationsCaps = 'NOTIFICATIONS';
  static const supportCaps = 'SUPPORT';
  static const aboutUs = 'About Us';
  static const usersGuide = "User's Guide";
  static const privacyPolicy = 'Privacy Policy';
  static const terms = 'Terms of Service';
  static const reportProblem = 'Report a Problem';
  static const sendFeedback = 'Send Feedback';
  static const removeAds = 'Remove Ads';
  static const logOutCaps = 'LOG OUT';
  static const ppcHome = 'https://prayerpalsapp.com';
  static const ppcGuide = 'https://www.prayerpalsapp.com/user-s-guide';
  static const ppcPolicy = 'https://www.prayerpalsapp.com/privacy-policy';
  static const ppcTerms = 'https://www.prayerpalsapp.com/terms-of-service';
  static const ppcSupport = 'Support@PrayerPalsApp.com';
  static const ppcInfo = 'Info@PrayerPalsApp.com';
  static const oldPassword = 'Old Password';
  static const newPassword = 'New Password';
  static const verifyPassword = 'Verify New Password';
  static const newPasswordMustMatch = 'New password must match';

//Buttons
  static const share = 'Share';
  static const search = 'Search';
  static const save = 'Save';
  static const cancel = 'Cancel';
  static const approve = 'Approve';
  static const join = 'Join';
  static const createGroup = 'Create Group';
  static const deleteGroup = 'Delete Group';
  static const groupMessage = 'Send Group Message';
  static const adminMessage = 'Send Message to Admin';
  static const inviteToGroup = 'Invite Member to Group';
  static const editGroupName = 'Edit Group Name';
  static const editGroup = 'Edit Group';
  static const invite = 'Invite';
  static const createMember = 'Create Member';
  static const create = 'Create';
  static const delete = 'Delete';
  static const deleteAccount = 'Delete Account';
  static const camera = 'Camera';
  static const photos = 'Photos';
  static const resignAdmin = 'Resign Admin';
  static const assignAdmin = 'Assign Admin';
  static const removeAdmin = 'Remove Admin';
  static const report = 'Report Abuse';
  static const daily = 'Daily';

//Hints
  static const keywords = 'Keyword(s)';
  static const groupName = 'Group Name';
  static const phoneNumber = 'Phone Number';

//Section Titles
  static const pendingRequests = 'Pending Requests';
  static const send = 'Send';
  static const app = 'App';
  static const text = 'Text';
  static const email = 'Email';
  static const myPrayer = 'My Prayer';
  static const group = 'group';
  static const updateProfilePicture = 'Update Profile Picture';
  static const personalNotifications = 'Personal Notifications';
  static const groupTags = 'Tags';
  static const creategroupErrorNoName = '- Please enter a name';
  static const groupDescription =
      'Enter group description here... You can place text and links to a prayer website, or online prayer meeting';
  static const ownerMessage =
      "You cannot remove the Group Owner from Admin in this screen. Only the group owner can remove Admin status from the Group Edit screen.";

  //Notifications
  static const justAFriendlyReminder =
      "Just a friendly reminder to pray today! God bless!";
  static const prayerReminder = 'Prayer Reminder';
}
