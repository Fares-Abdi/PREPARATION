import 'package:flutter/material.dart';

// Localization class to manage translations
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Method to determine if Arabic, English, or French should be displayed
  bool get isArabic => locale.languageCode == 'ar';
  bool get isEnglish => locale.languageCode == 'en';
  bool get isFrench => locale.languageCode == 'fr';

  String get home => isArabic ? "الرئيسية" : (isFrench ? "Accueil" : "Home");
  String get search => isArabic ? "بحث" : (isFrench ? "Rechercher" : "Search");
  String get favorites =>
      isArabic ? "المفضلة" : (isFrench ? "Favoris" : "Favorites");
  String get profile =>
      isArabic ? "الملف الشخصي" : (isFrench ? "Profil" : "Profile");

  // User data updated successfully
  String get userDataUpdatedSuccessfully => isArabic
      ? "تم تحديث بيانات المستخدم بنجاح"
      : (isFrench
          ? "Les données de l'utilisateur ont été mises à jour avec succès"
          : "User data updated successfully");

  String get selectThreeChoices => isArabic
      ? "حدد ثلاثة خيارات"
      : (isFrench ? "Sélectionnez trois choix" : "Select Three Choices");
  //
  // Please check your email to verify your account before logging in.
  String get verifyAccountBeforeLogin => isArabic
      ? "يرجى التحقق من بريدك الإلكتروني للتحقق من حسابك قبل تسجيل الدخول."
      : (isFrench
          ? "Veuillez vérifier votre e-mail pour vérifier votre compte avant de vous connecter."
          : "Please check your email to verify your account before logging in.");
  // // Verification email resent!
  // String get verificationEmailResent => isArabic
  //     ? "تم إعادة إرسال البريد الإلكتروني للتحقق!"
  //     : (isFrench
  //         ? "E-mail de vérification renvoyé!"
  //         : "Verification email resent!");
  // Passwords do not match. Please try again.
  String get passwordsDoNotMatch => isArabic
      ? "كلمات المرور غير متطابقة. يرجى المحاولة مرة أخرى."
      : (isFrench
          ? "Les mots de passe ne correspondent pas. Veuillez réessayer."
          : "Passwords do not match. Please try again.");
  // Welcome
  String get welcome =>
      isArabic ? "مرحبا" : (isFrench ? "Bienvenue" : "Welcome");
  // Sign-In failed. Please try again.
  String get signInFailed => isArabic
      ? "فشل تسجيل الدخول. يرجى المحاولة مرة أخرى."
      : (isFrench
          ? "Échec de la connexion. Veuillez réessayer."
          : "Sign-In failed. Please try again.");
  // Error during sign-in:
  String get errorDuringSignIn => isArabic
      ? "حدث خطأ أثناء تسجيل الدخول:"
      : (isFrench ? "Erreur lors de la connexion:" : "Error during sign-in:");
  // An unexpected error occurred:
  String get unexpectedErrorOccurred => isArabic
      ? "حدث خطأ غير متوقع:"
      : (isFrench
          ? "Une erreur inattendue s'est produite:"
          : "An unexpected error occurred:");
  // All fields are required. Please fill them in.
  String get allFieldsRequired => isArabic
      ? "جميع الحقول مطلوبة. يرجى ملئها."
      : (isFrench
          ? "Tous les champs sont obligatoires. Veuillez les remplir."
          : "All fields are required. Please fill them in.");
  // Error resending verification email. Please try again later.
  String get errorResendingVerificationEmail => isArabic
      ? "حدث خطأ أثناء إعادة إرسال البريد الإلكتروني للتحقق. يرجى المحاولة مرة أخرى في وقت لاحق."
      : (isFrench
          ? "Erreur lors de la réexpédition de l'e-mail de vérification. Veuillez réessayer plus tard."
          : "Error resending verification email. Please try again later.");
  // No user logged in
  String get noUserLoggedIn => isArabic
      ? "لا يوجد مستخدم مسجل"
      : (isFrench ? "Aucun utilisateur connecté" : "No user logged in");
  // No choices available
  String get noChoicesAvailable => isArabic
      ? "لا توجد خيارات متاحة"
      : (isFrench ? "Aucun choix disponible" : "No choices available");
  // Change Password
  String get changePassword => isArabic
      ? "تغيير كلمة المرور"
      : (isFrench ? "Changer le mot de passe" : "Change Password");
  // email or password are incorrect
  String get emailOrPasswordIncorrect => isArabic
      ? "البريد الإلكتروني أو كلمة المرور غير صحيحة"
      : (isFrench
          ? "L'e-mail ou le mot de passe est incorrect"
          : "Email or password are incorrect");

  // Notification Settings
  String get notificationSettings => isArabic
      ? "إعدادات الإشعارات"
      : (isFrench ? "Paramètres de notification" : "Notification Settings");

  // aboutApp
  String get aboutApp => isArabic
      ? "حول التطبيق"
      : (isFrench ? "À propos de l'application" : "About App");

  // Please add at least one skill, certification, and work experience
  String get addSkillsCertificationsWorkExperience => isArabic
      ? "يرجى إضافة مهارة وشهادة وخبرة عمل واحدة على الأقل"
      : (isFrench
          ? "Veuillez ajouter au moins une compétence, une certification et une expérience de travail"
          : "Please add at least one skill, certification, and work experience");
  // Select Gender
  String get selectGender => isArabic
      ? "اختر الجنس"
      : (isFrench ? "Sélection du sexe" : "Select Gender");
  // Male
  String get male => isArabic ? "ذكر" : (isFrench ? "Homme" : "Male");
  // Female
  String get female => isArabic ? "أنثى" : (isFrench ? "Femme" : "Female");

  // Select Age
  String get selectAge => isArabic
      ? "اختر العمر"
      : (isFrench ? "Sélectionnez l'âge" : "Select Age");
  // Select your age
  String get selectYourAge => isArabic
      ? "اختر عمرك"
      : (isFrench ? "Sélectionnez votre âge" : "Select your age");
  // Select exactly
  String get selectExactly => isArabic
      ? "يرجى اختيار بالضبط"
      : (isFrench ? "Veuillez sélectionner exactement" : "Select exactly");

  // User is not authenticated
  String get userNotAuthenticated => isArabic
      ? "المستخدم غير مصادق عليه"
      : (isFrench
          ? "L'utilisateur n'est pas authentifié"
          : "User is not authenticated");

  // Posted
  String get posted =>
      isArabic ? " نشر " : (isFrench ? " Publié " : " Posted ");

  // Location
  String get location =>
      isArabic ? " الموقع " : (isFrench ? " Emplacement " : " Location ");
  // Popular Services
  String get popularServices => isArabic
      ? "الخدمات الشائعة"
      : (isFrench ? "Services populaires" : "Popular Services");

  // Top Services
  String get topServices => isArabic
      ? "أفضل الخدمات"
      : (isFrench ? "Meilleurs services" : "Top Services");

  // All Services
  String get allServices => isArabic
      ? "جميع الخدمات"
      : (isFrench ? "Tous les services" : "All Services");

  // Are you sure you want to log out?
  String get areYouSureYouWantToLogout => isArabic
      ? "هل أنت متأكد أنك تريد تسجيل الخروج؟"
      : (isFrench
          ? "Êtes-vous sûr de vouloir vous déconnecter?"
          : "Are you sure you want to log out?");
  // Error fetching user data:
  String get errorFetchingUserData => isArabic
      ? "حدث خطأ أثناء جلب بيانات المستخدم"
      : (isFrench
          ? "Une erreur s'est produite lors de la récupération des données de l'utilisateur"
          : "An error occurred while fetching user data");

// Error deleting old profile picture
  String get errorDeletingOldProfilePicture => isArabic
      ? "حدث خطأ أثناء حذف الصورة الشخصية القديمة"
      : (isFrench
          ? "Une erreur s'est produite lors de la suppression de l'ancienne photo de profil"
          : "An error occurred while deleting the old profile picture");

// Error updating profile picture
  String get errorUpdatingProfilePicture => isArabic
      ? "حدث خطأ أثناء تحديث الصورة الشخصية"
      : (isFrench
          ? "Une erreur s'est produite lors de la mise à jour de la photo de profil"
          : "An error occurred while updating the profile picture");

  //errorSavingUserData
  String get errorSavingUserData => isArabic
      ? "حدث خطأ أثناء تحديث بيانات المستخدم"
      : (isFrench
          ? "Une erreur s'est produite lors de la mise à jour des données de l'utilisateur"
          : "An error occurred while updating user data");

  String get providerText =>
      isArabic ? "مزود الخدمة" : (isFrench ? "Fournisseur" : "Provider");
  // Sidebar Translations
  String get settings =>
      isArabic ? "الإعدادات" : (isFrench ? "Paramètres" : "Settings");
  String get logout =>
      isArabic ? "تسجيل الخروج" : (isFrench ? "Se déconnecter" : "Logout");
  String get language =>
      isArabic ? "اللغة" : (isFrench ? "Langue" : "Language");

  // Notifications
  String get notifications =>
      isArabic ? "الإشعارات" : (isFrench ? "Notifications" : "Notifications");
  String get becomeProviderButton => isArabic
      ? "أصبح مقدم الخدمة"
      : (isFrench ? "Devenir fournisseur" : "Become a Provider");

  // Listings
  String get listings =>
      isArabic ? "القوائم" : (isFrench ? "Listes" : "Listings");

  // New Review Received
  String get newReviewReceived => isArabic
      ? "لديك مراجعة جديدة على ملفك الشخصي"
      : (isFrench
          ? "Nouvel avis reçu sur votre profil"
          : "New review on your profile");
  // You have a new review on your profile
  String get youHaveNewReviewOnYourProfile => isArabic
      ? "لديك مراجعة جديدة على ملفك الشخصي"
      : (isFrench
          ? "Vous avez un nouvel avis sur votre profil"
          : "You have a new review on your profile");
  // Failed to add review. Please try again.
  String get failedToAddReview => isArabic
      ? "فشل إضافة المراجعة. يرجى المحاولة مرة أخرى."
      : (isFrench
          ? "Échec de l'ajout de l'avis. Veuillez réessayer."
          : "Failed to add review. Please try again.");

  // Review added successfully!
  String get reviewAddedSuccessfully => isArabic
      ? "تمت إضافة المراجعة بنجاح!"
      : (isFrench ? "Avis ajouté avec succès!" : "Review added successfully!");

  // Reviews
  String get reviews =>
      isArabic ? "المراجعات" : (isFrench ? "Avis" : "Reviews");

  // Add Review
  String get addReview =>
      isArabic ? "إضافة مراجعة" : (isFrench ? "Ajouter un avis" : "Add Review");

  // addComment
  String get addComment => isArabic
      ? "أضف تعليق"
      : (isFrench ? "Ajouter un commentaire" : "Add Comment");

  // submit
  String get submit => isArabic ? "إرسال" : (isFrench ? "Soumettre" : "Submit");
  // Submitting review
  String get submittingReview => isArabic
      ? "جارٍ تقديم المراجعة..."
      : (isFrench ? "Soumission de l'avis ..." : "Submitting review ...");
  // Sent
  String get sent => isArabic ? "المرسل" : (isFrench ? "Envoyé" : "Sent");

  // itsent
  String get itSent => isArabic ? "تم الإرسال" : (isFrench ? "Envoyé" : "Sent");

  // itreceived
  String get itReceived =>
      isArabic ? "تم الاستلام" : (isFrench ? "Reçu" : "Received");

  //  Received
  String get received =>
      isArabic ? "المستلم" : (isFrench ? "Reçu" : "Received");

  // No listings available
  String get noListingsAvailable => isArabic
      ? "لا توجد قوائم متاحة"
      : (isFrench ? "Aucune liste disponible" : "No listings available");

  // No reviews available
  String get noReviewsAvailable => isArabic
      ? "لا توجد مراجعات متاحة"
      : (isFrench ? "Aucun avis disponible" : "No reviews available");

  // Accept
  String get accept => isArabic ? "قبول" : (isFrench ? "Accepter" : "Accept");

  // Refuse
  String get refuse => isArabic ? "رفض" : (isFrench ? "Refuser" : "Refuse");
  // Negotiate
  String get negotiate =>
      isArabic ? "تفاوض" : (isFrench ? "Négocier" : "Negotiate");

  // Negotiate Price
  String get negotiatePrice => isArabic
      ? "التفاوض على السعر"
      : (isFrench ? "Négocier le prix" : "Negotiate Price");
  // Listing Refused
  String get listingRefused => isArabic
      ? "لقد قمت برفض العرض "
      : (isFrench ? "Liste refusée" : "Listing Refused");
  // counter_offer_sent
  String get counterOfferSent => isArabic
      ? "تم إرسال طلبك "
      : (isFrench ? "Contre-offre envoyée" : "Counter Offer Sent");
  // counter_offer_received
  String get counterOfferReceived => isArabic
      ? "تم استلام عرض "
      : (isFrench ? "Contre-offre reçue" : "Counter Offer Received");
  //  Listing accepted successfully
  String get listingAcceptedSuccessfully => isArabic
      ? "لقد قمت بقبول العرض "
      : (isFrench
          ? "Liste acceptée avec succès"
          : "Listing accepted successfully");
  // Negotiation History
  String get negotiationHistory => isArabic
      ? "تاريخ التفاوض"
      : (isFrench ? "Historique de négociation" : "Negotiation History");

  // Counter offer received
  String get counterOfferReceivedText => isArabic
      ? "تم استلام عرض "
      : (isFrench ? "Contre-offre reçue" : "Counter Offer Received");

  // Listing status updated successfully
  String get listingStatusUpdatedSuccessfully => isArabic
      ? "لقد تم تحديث العرض "
      : (isFrench
          ? "Statut de la liste mis à jour avec succès"
          : "Listing status updated successfully");
  // Your Counter Offer
  String get yourCounterOffer => isArabic
      ? " سعر عرضك"
      : (isFrench ? "Votre contre-offre" : "Your Counter Offer");
  // active
  String get active => isArabic ? "مقبول" : (isFrench ? "Actif" : "Active");

  // pending
  String get pending =>
      isArabic ? "قيد الانتظار" : (isFrench ? "En attente" : "Pending");

  // completed
  String get completed =>
      isArabic ? "مكتمل" : (isFrench ? "Terminé" : "Completed");
  // canceled
  String get canceled => isArabic ? "ملغى" : (isFrench ? "Annulé" : "Canceled");
  // New Counter Offer
  String get newCounterOffer => isArabic
      ? "عرض جديد"
      : (isFrench ? "Nouvelle contre-offre" : "New Counter Offer");

  // You received a counter offer of
  String get youReceivedCounterOfferOf => isArabic
      ? "لقد تلقيت عرضًا بقيمة"
      : (isFrench
          ? "Vous avez reçu une contre-offre de"
          : "You received a counter offer of");
  // You received a counter offer of
  String get youSentCounterOfferOf => isArabic
      ? "تم إرسال عرضك بقيمة"
      : (isFrench
          ? "Vous avez reçu une contre-offre de"
          : "You received a counter offer of");
  // // You received a counter offer of
  String get successfully =>
      isArabic ? "بنجاح !" : (isFrench ? " avec succès !" : "successfully !");

  // for
  String get forText => isArabic ? "لـ" : (isFrench ? "pour" : "for");

  // Failed to send counter offer. Please try again.
  String get failedToSendCounterOffer => isArabic
      ? "فشل إرسال العرض . يرجى المحاولة مرة أخرى."
      : (isFrench
          ? "Échec de l'envoi de la contre-offre. Veuillez réessayer."
          : "Failed to send counter offer. Please try again.");
  // Send Offer
  String get sendOffer =>
      isArabic ? "إرسال العرض" : (isFrench ? "Envoyer l'offre" : "Send Offer");
  // Current offer
  String get currentOffer => isArabic
      ? "العرض الحالي"
      : (isFrench ? "Offre actuelle" : "Current offer");

  // step2Button
  String get step2Button =>
      isArabic ? "اخر خطوة" : (isFrench ? "Dernière étape" : "Final Step");

  String get copiedToClipboard => isArabic
      ? "تم نسخها إلى الحافظة"
      : (isFrench ? "Copié Dans Le Presse-papiers" : "Copied To Clipboard ");
  // waitingButton
  String get waitingButton => isArabic
      ? "يتم التحقق من هويتك"
      : (isFrench
          ? "identité en cours de vérification"
          : "Your identity is being verified");

  // waitingMessage "Wait For Manual Verifcation"
  String get waitingMessage => isArabic
      ? "انتظر التحقق اليدوي"
      : (isFrench
          ? "Attendez la vérification manuelle"
          : "Wait For Manual Verifcation");

// verificationButton "Identity Verification"
  String get verificationButton => isArabic
      ? " 2 التحقق من الهوية "
      : (isFrench ? "Vérification d'identité  2 " : "Identity Verification 2 ");

  // Common Buttons
  String get save => isArabic ? "حفظ" : (isFrench ? "Enregistrer" : "Save");
  String get cancel => isArabic ? "إلغاء" : (isFrench ? "Annuler" : "Cancel");

  String get saveProfile => isArabic
      ? "حفظ الملف الشخصي"
      : (isFrench ? " Enregistrer le profil" : "Save Profile");

  // Error Messages
  String get error => isArabic
      ? "حدث خطأ"
      : (isFrench ? "Une erreur est survenue" : "An error occurred");

// 'No user logged in'
  // Okay Messages
  String get okay => isArabic ? "حسنا" : (isFrench ? "D'accord" : "OK");

  String get noInternet => isArabic
      ? "لا يوجد اتصال بالإنترنت"
      : (isFrench ? "Pas de connexion Internet" : "No Internet connection");

  String get aboutMe =>
      isArabic ? "نبـذة عني" : (isFrench ? "À propos de moi" : "About Me");

  // workDomain
  String get workDomain => isArabic
      ? "مجال العمل"
      : (isFrench ? "Domaine de travail" : "Work Domain");

  // New localization for no favorite services
  String get noFavoriteServicesYet => isArabic
      ? "لا توجد خدمات مفضلة بعد"
      : (isFrench
          ? "Aucun service favori pour le moment"
          : "No favorite services yet");

  // Filter Services
  String get filterServices => isArabic
      ? "تصفية الخدمات"
      : (isFrench ? "Filtrer les services" : "Filter Services");

  // Clear Filters
  String get clearFilters => isArabic
      ? "مسح الفلاتر"
      : (isFrench ? "Effacer les filtres" : "Clear Filters");

  // Apply Filters
  String get applyFilters => isArabic
      ? "تطبيق الفلاتر"
      : (isFrench ? "Appliquer les filtres" : "Apply Filters");

  // New localization for NameEntryScreen
  String get firstName =>
      isArabic ? "الاسم الأول" : (isFrench ? "Prénom" : "First Name");
  String get lastName =>
      isArabic ? "الاسم الأخير" : (isFrench ? "Nom de famille" : "Last Name");
  String get selectYourServices => isArabic
      ? "اختر خدمتك:"
      : (isFrench ? "Sélectionnez vos services:" : "Select Your Service:");
  String get selectOneChoice => isArabic
      ? "يرجى اختيار خيار واحد فقط."
      : (isFrench
          ? "Veuillez sélectionner un seul choix."
          : "Please select only one choice.");

  String get continueButton =>
      isArabic ? "استمر" : (isFrench ? "Continuer" : "Continue");
  String get firstNameLastNameRequired => isArabic
      ? "الاسم الأول واسم العائلة مطلوبان."
      : (isFrench
          ? "Le prénom et le nom de famille sont obligatoires."
          : "First Name and Last Name are required.");
  // Add retry localization
  String get retry =>
      isArabic ? "إعادة المحاولة" : (isFrench ? "Réessayer" : "Retry");

  // babysitter
  String get babysitter =>
      isArabic ? " مربية أطفال " : (isFrench ? "Babysitter" : "Babysitter");

  String get firstNameRequired => isArabic
      ? "الاسم الأول مطلوب."
      : (isFrench ? "Le prénom est obligatoires." : "First Name is required.");

  String get LastNameRequired => isArabic
      ? "اسم العائلة مطلوب."
      : (isFrench ? "Le nom est obligatoires." : "Last Name is required.");

  String get selectTwoWorkChoices => isArabic
      ? "يرجى اختيار خيارين بالضبط."
      : (isFrench
          ? "Veuillez sélectionner exactement deux choix de travail."
          : "Please select exactly two work choices.");
  String get enterYourDetails => isArabic
      ? "أدخل تفاصيلك"
      : (isFrench ? "Entrez vos coordonnées" : "Enter Your Details");
  String get ok => isArabic ? "حسنا" : (isFrench ? "D'accord" : "OK");

  // New localization for OnboardingScreen2
  String get verifyYourIdentity => isArabic
      ? "تحقق من هويتك"
      : (isFrench ? "Vérifiez votre identité" : "Verify Your Identity");
  String get verifyIdentityDescription => isArabic
      ? "لأمانك، نحتاج إلى تأكيد هويتك. هذا يضمن تجربة موثوقة وآمنة للجميع."
      : (isFrench
          ? "Pour votre sécurité, nous devons confirmer votre identité. Cela garantit une expérience fiable et sécurisée pour tout le monde."
          : "For your security, we need to confirm your identity. This ensures a trusted and secure experience for everyone.");

  // New localization for work choices
  String get houseCleaning => isArabic
      ? "تنظيف المنازل"
      : (isFrench ? "Nettoyage maison" : "House Cleaning");
  String get electricity =>
      isArabic ? "كهرباء" : (isFrench ? "Électricité" : "Electricity");
  String get plumbing =>
      isArabic ? "سباكة" : (isFrench ? "Plomberie" : "Plumbing");
  String get gardening =>
      isArabic ? "البستنة" : (isFrench ? "Jardinage" : "Gardening");
  String get painting =>
      isArabic ? "دهان" : (isFrench ? "Peinture" : "Painting");
  String get carpentry =>
      isArabic ? "نجارة" : (isFrench ? "Menuiserie" : "Carpentry");
  String get pestControl => isArabic
      ? "مكافحة الآفات"
      : (isFrench ? "Lutte antiparasitaire" : "Pest Control");
  String get acRepair => isArabic
      ? "إصلاح مكيف الهواء"
      : (isFrench ? "Réparation AC" : "AC Repair");
  String get vehicleRepair => isArabic
      ? "إصلاح المركبات"
      : (isFrench ? "Réparation véhicule" : "Vehicle Repair");
  String get applianceInstallation => isArabic
      ? "تركيب الأجهزة"
      : (isFrench ? "Installation appareils" : "Appliance Installation");
  String get itSupport => isArabic
      ? "دعم تكنولوجيا المعلومات"
      : (isFrench ? "Support informatique" : "IT Support");
  String get homeSecurity => isArabic
      ? "أمن المنزل"
      : (isFrench ? "Sécurité domicile" : "Home Security");
  String get interiorDesign => isArabic
      ? "تصميم داخلي"
      : (isFrench ? "Design intérieur" : "Interior Design");
  String get windowCleaning => isArabic
      ? "تنظيف النوافذ"
      : (isFrench ? "Nettoyage fenêtres" : "Window Cleaning");
  String get furnitureAssembly => isArabic
      ? "تجميع الأثاث"
      : (isFrench ? "Assemblage meubles" : "Furniture Assembly");

  // New localization for id_verification_screen
  String get realTimeDetection => isArabic
      ? "الكشف في الوقت الحقيقي"
      : (isFrench ? "Détection en temps réel" : "Real-Time Detection");

  // Upload Front ID
  String get uploadFrontID => isArabic
      ? "تحميل الهوية الأمامية"
      : (isFrench ? "Télécharger l'identifiant avant" : "Upload Front ID");

  String get support => isArabic ? "الدعم" : (isFrench ? "Soutien" : "Support");
  String get supportMessage => isArabic
      ? "إذا لم يتم اكتشاف بطاقتك، يرجى التأكد من أنها محاذية بشكل صحيح وحاول مرة أخرى."
      : (isFrench
          ? "Si votre carte n'a pas été détectée, assurez-vous qu'elle est correctement alignée et réessayez."
          : "If your card was not detected, please make sure it is aligned correctly and try again.");
  String get stopDetection => isArabic
      ? "إيقاف الكشف"
      : (isFrench ? "Arrêter la détection" : "Stop Detection");
  String get startDetection => isArabic
      ? "بدء الكشف"
      : (isFrench ? "Commencer la détection" : "Start Detection");
  String get skip => isArabic ? "تخطي" : (isFrench ? "Sauter" : "Skip");
  String get uploadLabel =>
      isArabic ? "تحميل" : (isFrench ? "Télécharger" : "Upload");

  String get retake => isArabic ? "إعادة" : (isFrench ? "Reprendre" : "Retake");

  // New localization for face_verification_screen
  String get faceVerification => isArabic
      ? "التحقق من الوجه"
      : (isFrench ? "Vérification du visage" : "Face Verification");
  String get faceVerificationSupportMessage => isArabic
      ? "يرجى التأكد من أن وجهك مرئي بوضوح داخل الدليل البيضاوي وانظر مباشرة إلى الكاميرا. حافظ على وجهك في المنتصف واحتفظ بتعبير محايد."
      : (isFrench
          ? "Veuillez vous assurer que votre visage est clairement visible dans le guide ovale et regardez directement la caméra. Gardez votre visage centré et maintenez une expression neutre."
          : "Please ensure your face is clearly visible within the oval guide and look directly at the camera. Keep your face centered and maintain a neutral expression.");
  String get verifyFace => isArabic
      ? "تحقق من الوجه"
      : (isFrench ? "Vérifier le visage" : "Verify Face");

  // Profile Page
  String get editProfile => isArabic
      ? "تعديل الملف الشخصي"
      : (isFrench ? "Modifier le profil" : "Edit Profile");
  String get contactSupport => isArabic
      ? "اتصل بالدعم"
      : (isFrench ? "Contacter le support" : "Contact Support");
  String get name => isArabic ? "الاسم" : (isFrench ? "Nom" : "Name");
  String get projects =>
      isArabic ? "المشاريع" : (isFrench ? "Projets" : "Projects");
  String get rating =>
      isArabic ? "التقييم" : (isFrench ? "Évaluation" : "Rating");
  String get hourlyRate => isArabic
      ? "معدل الأجر بالساعة"
      : (isFrench ? "Tarif horaire" : "Hourly Rate");

  String get hourlyRateRequiredError => isArabic
      ? "يرجى تحديد معدل الأجر بالساعة لإتمام العملية."
      : (isFrench
          ? "Veuillez préciser votre tarif horaire pour continuer."
          : "Please specify your hourly rate to proceed.");

  String get aboutMeLabel =>
      isArabic ? "عني" : (isFrench ? "À propos de moi" : "About Me");
  String get writeAboutYourself => isArabic
      ? "اكتب عن نفسك"
      : (isFrench ? "Écrivez sur vous" : "Write about yourself");
  String get skills =>
      isArabic ? "المهارات" : (isFrench ? "Compétences" : "Skills");
  String get addSkill => isArabic
      ? "أضف مهارة"
      : (isFrench ? "Ajouter une compétence" : "Add Skill");
  String get noSkillsAvailable => isArabic
      ? "لا توجد مهارات متاحة"
      : (isFrench ? "Aucune compétence disponible" : "No skills available");
  String get workExperience => isArabic
      ? "الخبرة العملية"
      : (isFrench ? "Expérience\nprofessionnelle" : "Work Experience");

  String get companyName => isArabic
      ? "اسم الشركة"
      : (isFrench ? "Nom de l'entreprise" : "Company Name");
  String get position =>
      isArabic ? "المنصب" : (isFrench ? "Poste" : "Position");
  String get duration => isArabic ? "خلال" : (isFrench ? "Durée" : "Duration");
  // durationFrom
  String get durationFrom => isArabic ? "من" : (isFrench ? "De" : "From");
  // durationTo
  String get durationTo => isArabic ? "إلى" : (isFrench ? "À" : "To");
  String get addWorkExperience => isArabic
      ? "أضف خبرة عمل"
      : (isFrench ? "Ajouter une expérience" : "Add Work Experience");
  String get noWorkExperienceAvailable => isArabic
      ? "لا توجد خبرة عمل متاحة"
      : (isFrench
          ? "Aucune expérience professionnelle disponible"
          : "No work experience available");
  String get portfolio =>
      isArabic ? "المعرض" : (isFrench ? "Portfolio" : "Portfolio");
  String get noPortfolioImagesAvailable => isArabic
      ? "لا توجد صور في المعرض"
      : (isFrench
          ? "Aucune image dans le portfolio"
          : "No portfolio images available");
  String get addPortfolioImage => isArabic
      ? "أضف صورة إلى المعرض"
      : (isFrench ? "Ajouter une image au portfolio" : "Add Portfolio Image");

  String get noPortfolioImages => isArabic
      ? "لا توجد صور متوفرة في المعرض."
      : (isFrench
          ? "Aucune image de portfolio disponible."
          : "No portfolio images available");
  String get certifications =>
      isArabic ? "الشهادات" : (isFrench ? "Certifications" : "Certifications");
  String get addCertification => isArabic
      ? "أضف شهادة"
      : (isFrench ? "Ajouter une certification" : "Add Certification");
  String get noCertificationsAvailable => isArabic
      ? "لا توجد شهادات متاحة"
      : (isFrench
          ? "Aucune certification disponible"
          : "No certifications available");

  // contact Provider
  String get contactProvider => isArabic
      ? "اتصل بمزود الخدمة"
      : (isFrench ? "Contacter le fournisseur" : "Contact Provider");

  // Contact Information
  String get contactInformation => isArabic
      ? "معلومات الاتصال"
      : (isFrench ? "Coordonnées" : "Contact Information");

  // Send Direct Listing
  String get sendDirectListing => isArabic
      ? "إرسال قائمة مباشرة"
      : (isFrench ? "faire une demande" : "Send Direct Listing");

  // Send Direct Job Listing
  String get sendDirectJobListing => isArabic
      ? "إرسال قائمة وظائف مباشرة"
      : (isFrench
          ? "Envoyer une liste d'emplois directe"
          : "Send Direct Job Listing");

  // Main Title
  String get mainTitle => isArabic
      ? "العنوان الرئيسي"
      : (isFrench ? "Titre principal" : "Main Title");
  // Please enter a title
  String get pleaseEnterTitle => isArabic
      ? "الرجاء إدخال عنوان"
      : (isFrench ? "Veuillez entrer un titre" : "Please enter a title");

  // Description
  String get description =>
      isArabic ? "الوصف" : (isFrench ? "Description" : "Description");
  // Please enter a description
  String get pleaseEnterDescription => isArabic
      ? "الرجاء إدخال وصف"
      : (isFrench
          ? "Veuillez entrer une description"
          : "Please enter a description");

  // Pay
  String get pay => isArabic ? "الدفع" : (isFrench ? "Payer" : "Pay");
  //Please enter the pay
  String get pleaseEnterPay => isArabic
      ? "الرجاء إدخال مبلغ الدفع"
      : (isFrench ? "Veuillez entrer le paiement" : "Please enter the pay");

  // Location
  String get locationRequiredError => isArabic
      ? "يرجى تحديد الموقع"
      : (isFrench
          ? "Veuillez sélectionner l'emplacement"
          : "Please select the location");

  // Sending listing...
  String get sendingListing => isArabic
      ? "إرسال القائمة..."
      : (isFrench ? "Envoi de la liste..." : "Sending listing...");

  // sendListing
  String get sendListing => isArabic
      ? "إرسال القائمة"
      : (isFrench ? "Envoyer la liste" : "Send Listing");

  // Failed to send listing. Please try again.
  String get failedToSendListing => isArabic
      ? "فشل إرسال. يرجى المحاولة مرة أخرى."
      : (isFrench
          ? "Échec de l'envoi de la liste. Veuillez réessayer."
          : "Failed to send listing. Please try again.");
  // Job listing sent successfully!
  String get jobListingSentSuccessfully => isArabic
      ? "تم إرسال قائمة الوظائف بنجاح!"
      : (isFrench
          ? "Liste d's envoyée avec succès!"
          : "Job listing sent successfully!");

  // close
  String get close => isArabic ? "إغلاق" : (isFrench ? "Fermer" : "Close");

  // Admin Profile
  String get manageUsers => isArabic
      ? "إدارة المستخدمين"
      : (isFrench ? "Gérer les utilisateurs" : "Manage Users");
  String get manageReviews => isArabic
      ? "إدارة المراجعات"
      : (isFrench ? "Gérer Les Avis" : "Manage Reviews");
  String get manualVerification => isArabic
      ? "التحقق اليدوي"
      : (isFrench ? "Vérification manuelle" : "Manual Verification");

  // Password recovery translations
  String get enterValidEmail => isArabic
      ? ".يرجى إدخال بريد إلكتروني صالح"
      : (isFrench
          ? "Veuillez entrer une adresse e-mail valide."
          : "Please enter a valid email.");
  // An error occurred during signup
  String get signupError => isArabic
      ? "حدث خطأ أثناء التسجيل. يرجى التحقق من اتصالك بالشبكة."
      : (isFrench
          ? "Une erreur s'est produite lors de l'inscription. Veuillez vérifier votre connexion réseau."
          : "An error occurred during signup. Please check your network connection.");
  // Please verify your email before logging in.
  String get verifyEmailBeforeLogin => isArabic
      ? "يرجى التحقق من بريدك الإلكتروني قبل تسجيل الدخول."
      : (isFrench
          ? "Veuillez vérifier votre e-mail avant de vous connecter."
          : "Please verify your email before logging in.");
  // Resend
  String get resend =>
      isArabic ? "إعادة إرسال" : (isFrench ? "Renvoyer" : "Resend");
  // Verification email resent! Please check your inbox.
  String get verificationEmailResent => isArabic
      ? "تم إعادة إرسال البريد الإلكتروني للتحقق! يرجى التحقق من صندوق الوارد الخاص بك."
      : (isFrench
          ? "E-mail de vérification renvoyé! Veuillez vérifier votre boîte de réception."
          : "Verification email resent! Please check your inbox.");
  // Error resending verification email. Please try again later.
  String get resendVerificationEmailError => isArabic
      ? "خطأ في إعادة إرسال البريد الإلكتروني للتحقق. يرجى المحاولة مرة أخرى لاحقًا."
      : (isFrench
          ? "Erreur lors de la réexpédition de l'e-mail de vérification. Veuillez réessayer plus tard."
          : "Error resending verification email. Please try again later.");
  // Login Successful. Welcome
  String get loginSuccessfulWelcome => isArabic
      ? "تم تسجيل الدخول بنجاح. مرحبًا"
      : (isFrench
          ? "Connexion réussie. Bienvenue"
          : "Login Successful. Welcome");
  // No user found.
  String get noUserFound => isArabic
      ? "لم يتم العثور على المستخدم."
      : (isFrench ? "Aucun utilisateur trouvé." : "No user found.");
  // Please enter both email and password.
  String get enterBothEmailAndPassword => isArabic
      ? "يرجى إدخال كل من البريد الإلكتروني وكلمة المرور."
      : (isFrench
          ? "Veuillez entrer à la fois l'e-mail et le mot de passe."
          : "Please enter both email and password.");
  String get networkError => isArabic
      ? "خطأ في الشبكة. يرجى المحاولة مرة أخرى لاحقًا."
      : (isFrench
          ? "Erreur réseau. Veuillez réessayer plus tard."
          : "Network error. Please try again later.");

  String get emailNotFound => isArabic
      ? "البريد الإلكتروني غير موجود. يرجى التحقق والمحاولة مرة أخرى."
      : (isFrench
          ? "E-mail introuvable. Veuillez vérifier et réessayer."
          : "Email not found. Please check and try again.");

  String get passwordResetEmailSent => isArabic
      ? "تم إرسال بريد إلكتروني لإعادة تعيين كلمة المرور إلى بريدك الإلكتروني."
      : (isFrench
          ? "Un e-mail de réinitialisation du mot de passe a été envoyé à votre boîte de réception."
          : "A password reset email has been sent to your inbox.");

// Profile nameChangeLimit translations
  String get nameChangeLimit => isArabic
      ? "يمكنك تغيير حرفين فقط في إسمك."
      : (isFrench
          ? "Vous ne pouvez changer que deux caractères dans vos noms."
          : "You can only change up to 2 characters in your names.");

  // Profile Profession translations
  String get profession =>
      isArabic ? "المهنة" : (isFrench ? "Profession" : "Profession");
  String get professionRequiredError => isArabic
      ? "يرجى تحديد مهنتك"
      : (isFrench
          ? "Veuillez sélectionner votre profession."
          : "Please select your profession.");
  // Profile address translations
  String get wilaya => isArabic ? "الولاية" : (isFrench ? "Wilaya" : "Wilaya");
  String get wilayaRequiredError => isArabic
      ? "يرجى اختيار ولايتك"
      : (isFrench
          ? "Veuillez sélectionner votre Wilaya."
          : "Please select your Wilaya.");
  String get commune =>
      isArabic ? "البلدية" : (isFrench ? "Commune" : "Commune");
  String get communeRequiredError => isArabic
      ? "يرجى اختيار بلديتك"
      : (isFrench
          ? "Veuillez sélectionner votre Commune."
          : "Please select your Commune.");
  // Onboarding translations
  // Get the language name based on the current locale
  String get englishLanguageName =>
      isArabic ? "الإنجليزية" : (isFrench ? "Anglais" : "English");
  String get arabicLanguageName =>
      isArabic ? "العربية" : (isFrench ? "Arabe" : "Arabic");
  String get frenchLanguageName =>
      isArabic ? "الفرنسية" : (isFrench ? "Français" : "French");
  String get onboardingTitle1 => isArabic
      ? "اكتشف خدمات الحرفيين"
      : (isFrench
          ? "Découvrez les services de bricoleurs"
          : "Discover Handyman Services");
  String get onboardingDescription1 => isArabic
      ? "اكتشف خدمات الحرفيين الموثوقين عند أطراف أصابعك."
      : (isFrench
          ? "Découvrez les services de bricoleurs fiables à portée de main."
          : "Discover trusted handyman services at your fingertips.");
  String get onboardingTitle2 => isArabic
      ? "احجز بسهولة"
      : (isFrench ? "Réservez facilement" : "Book Easily");
  String get onboardingDescription2 => isArabic
      ? "عملية الحجز بسيطة لتحديد مواعيد الخدمات في الوقت الذي يناسبك."
      : (isFrench
          ? "Le processus de réservation est simple pour planifier des services à votre convenance."
          : "The booking process is simple to schedule services at your convenience.");
  String get onboardingTitle3 => isArabic
      ? "قيم وراجع"
      : (isFrench ? "Évaluez et laissez un avis" : "Rate and Review");
  String get onboardingDescription3 => isArabic
      ? "شارك تجربتك وساعد الآخرين في العثور على أفضل الخدمات."
      : (isFrench
          ? "Partagez votre expérience et aidez les autres à trouver les meilleurs services."
          : "Share your experience and help others find the best services.");
  String get getStarted => isArabic
      ? "ابدأ الآن"
      : (isFrench ? "Commencer maintenant" : "Get Started Now");
  String get next => isArabic ? "التالي" : (isFrench ? "Suivant" : "Next");

  // Login translations
  String get loginTitle =>
      isArabic ? "تسجيل الدخول" : (isFrench ? "Connexion" : "Login");
  String get loginDescription => isArabic
      ? "قم بتسجيل الدخول إلى حسابك للبدء"
      : (isFrench
          ? "Connectez-vous à votre compte pour commencer"
          : "Log into your account to get started");
  String get email =>
      isArabic ? "البريد الإلكتروني" : (isFrench ? "E-mail" : "Email");
  String get password =>
      isArabic ? "كلمة المرور" : (isFrench ? "Mot de passe" : "Password");
  String get loginButton =>
      isArabic ? "تسجيل الدخول" : (isFrench ? "Se connecter" : "Login");
  String get forgotPassword => isArabic
      ? "نسيت كلمة المرور؟"
      : (isFrench ? "Mot de passe oublié?" : "Forgot password?");
  String get googleSignIn => isArabic
      ? "تسجيل الدخول باستخدام جوجل"
      : (isFrench ? "Se connecter avec Google" : "Sign in with Google");
  String get createAccount => isArabic
      ? "إنشاء حساب جديد"
      : (isFrench ? "Créer un nouveau compte" : "Create a new account");

  // Signup screen translations
  String get signupTitle => isArabic
      ? "إنشاء حساب"
      : (isFrench ? "Créer un compte" : "Create Account");

  String get nameLabel => isArabic ? "الاسم" : (isFrench ? "Nom" : "Name");

  String get emailLabel =>
      isArabic ? "البريد الإلكتروني" : (isFrench ? "E-mail" : "Email");

  String get passwordLabel =>
      isArabic ? "كلمة المرور" : (isFrench ? "Mot de passe" : "Password");

  String get passwordCheckLabel => isArabic
      ? "أعد كتابة كلمة المرور"
      : (isFrench ? "Confirmez le Mot de passe" : "Confirm Password");

  String get phoneLabel =>
      isArabic ? "رقم الهاتف" : (isFrench ? "Numéro de téléphone" : "Phone");

  String get termsAgreement => isArabic
      ? "أوافق على الشروط والأحكام"
      : (isFrench
          ? "J'accepte les termes"
          : "I agree to the Terms and Conditions");

  String get signInWithGoogle => isArabic
      ? "تسجيل الدخول باستخدام Google"
      : (isFrench ? "Se connecter avec Google" : "Sign in with Google");

  String get signupButton =>
      isArabic ? "إنشاء حساب" : (isFrench ? "Créer un compte" : "Sign Up");
  // Already have an account? Login
  String get alreadyHaveAnAccount => isArabic
      ? "لديك حساب بالفعل؟ تسجيل الدخول"
      : (isFrench
          ? "Vous avez déjà un compte ? Connexion"
          : "Already have an account? Login");

  String get termsAgreementLink => isArabic
      ? "الشروط والأحكام"
      : (isFrench ? "Conditions d'utilisation" : "Terms and Conditions");

  String get termsAgreementPrefix => isArabic
      ? "أوافق على "
      : (isFrench ? "J'accepte les " : "I agree to the ");

  String get loginButtonText => isArabic
      ? "لديك حساب بالفعل؟ تسجيل الدخول"
      : (isFrench
          ? "Vous avez déjà un compte ? Connexion"
          : "Already have an account? Login");
  String get passwordRequiredError => isArabic
      ? "الرجاء إدخال كلمة المرور"
      : (isFrench
          ? "Veuillez entrer un mot de passe"
          : "Please enter your password");

  String get passwordMinLengthError => isArabic
      ? "كلمة المرور يجب أن تكون على الأقل 8 أحرف"
      : (isFrench
          ? "Le mot de passe doit comporter au moins 8 caractères"
          : "Password must be at least 8 characters long");

  String get emailRequiredError => isArabic
      ? "الرجاء إدخال البريد الإلكتروني"
      : (isFrench
          ? "Veuillez entrer une adresse e-mail"
          : "Please enter your email");

  String get emailInvalidError => isArabic
      ? "الرجاء إدخال بريد إلكتروني صالح"
      : (isFrench
          ? "Veuillez entrer une adresse e-mail valide"
          : "Please enter a valid email");
  // Invalid email format.
  String get invalidEmailFormat => isArabic
      ? "البريد الإلكتروني غير صالح."
      : (isFrench ? "Format d'e-mail invalide." : "Invalid email format.");
  // This account has been disabled.
  String get accountDisabled => isArabic
      ? "تم تعطيل هذا الحساب."
      : (isFrench
          ? "Ce compte a été désactivé."
          : "This account has been disabled.");
  // Too many failed login attempts. Please try again later.
  String get tooManyFailedAttempts => isArabic
      ? "الكثير من محاولات تسجيل الدخول الفاشلة. يرجى المحاولة مرة أخرى لاحقًا."
      : (isFrench
          ? "Trop de tentatives de connexion échouées. Veuillez réessayer plus tard."
          : "Too many failed login attempts. Please try again later.");
  // An unknown error occurred.
  String get unknownError => isArabic
      ? "حدث خطأ غير معروف."
      : (isFrench
          ? "Une erreur inconnue s'est produite."
          : "An unknown error occurred.");
  // Incorrect password.
  String get incorrectPassword => isArabic
      ? "كلمة المرور غير صحيحة."
      : (isFrench ? "Mot de passe incorrect." : "Incorrect password.");

  // Delete Review
  String get deleteReview => isArabic
      ? "حذف المراجعة"
      : (isFrench ? "Supprimer l'avis" : "Delete Review");
  // Review deleted successfully
  String get reviewDeletedSuccessfully => isArabic
      ? "تم حذف المراجعة بنجاح"
      : (isFrench
          ? "Avis supprimé avec succès"
          : "Review deleted successfully");
  // Failed to delete review
  String get failedToDeleteReview => isArabic
      ? "فشل حذف المراجعة. يرجى المحاولة مرة أخرى."
      : (isFrench
          ? "Échec de la suppression de l'avis. Veuillez réessayer."
          : "Failed to delete review. Please try again.");
  // Are you sure you want to delete this review?
  String get deleteReviewConfirmation => isArabic
      ? "هل أنت متأكد أنك تريد حذف هذه المراجعة؟"
      : (isFrench
          ? "Voulez-vous vraiment supprimer cet avis?"
          : "Are you sure you want to delete this review?");
  // Delete
  String get delete => isArabic ? "حذف" : (isFrench ? "Supprimer" : "Delete");
  // Provider Reviews
  String get providerReviews => isArabic
      ? "مراجعات المزود"
      : (isFrench ? "Avis du fournisseur" : "Provider Reviews");
  // Error fetching reviews. Please try again later.
  String get errorFetchingReviews => isArabic
      ? "خطأ في جلب المراجعات. يرجى المحاولة مرة أخرى لاحقًا."
      : (isFrench
          ? "Erreur lors de la récupération des avis. Veuillez réessayer plus tard."
          : "Error fetching reviews. Please try again later.");
  // Comment Management
  String get commentManagement => isArabic
      ? "إدارة التعليقات"
      : (isFrench ? "Gestion des commentaires" : "Comment Management");

  String get fieldRequiredError => isArabic
      ? "هذا الحقل مطلوب."
      : (isFrench ? "Ce champ est requis." : "This field is required.");
  // Service Providers
  String get serviceProviders => isArabic
      ? "مقدمي الخدمات"
      : (isFrench ? "Fournisseurs de services" : "Service Providers");
  // No user found for that email.
  String get noUserFoundForEmail => isArabic
      ? "لم يتم العثور على مستخدم لهذا البريد الإلكتروني."
      : (isFrench
          ? "Aucun utilisateur trouvé pour cet e-mail."
          : "No user found for that email.");

  // Home Screen translations
  String get appTitle => isArabic ? "هنيني" : (isFrench ? "Hanini" : "Hanini");
  String get searchHint => isArabic
      ? "ابحث عن خدمات..."
      : (isFrench ? "Recherchez des services..." : "Search for services...");
  String get topService => isArabic
      ? "الخدمات المميزة"
      : (isFrench ? "Services principaux" : "Top Services");

  String get menu => isArabic ? "القائمة" : (isFrench ? "Menu" : "Menu");

  String get provider =>
      isArabic ? "المزود" : (isFrench ? "Fournisseur" : "Provider");

  String get phone => isArabic
      ? "رقم الهاتف"
      : (isFrench ? "numéro de téléphone" : "phone number");

  String get phoneRequiredError => isArabic
      ? "يرجى إدخال رقم الهاتف"
      : (isFrench
          ? "Veuillez entrer le numéro de téléphone"
          : "Please enter phone number");

  String get phoneInvalidError => isArabic
      ? "رقم الهاتف غير صالح"
      : (isFrench ? "Numéro de téléphone invalide" : "Invalid phone number");
  String get selectLanguage => isArabic
      ? "اختر اللغة"
      : (isFrench ? "Sélectionner la langue" : "Select Language");

  String get services =>
      isArabic ? "خدمات" : (isFrench ? "service" : "services");

  String get myProfile =>
      isArabic ? "ملفي الشخصي" : (isFrench ? "mon profil" : "My Profile");

  String get appName => isArabic
      ? "اسم التطبيق"
      : (isFrench ? "Nom de l'application" : "App Name");

  String get sponsoredServices => isArabic
      ? "الخدمات الممولة"
      : (isFrench ? "Services sponsorisés" : "Sponsored Services");

  String get homePage => isArabic
      ? "الصفحة الرئيسية"
      : (isFrench ? "Page d'accueil" : "Home Page");

  String get setupYourProfile => isArabic
      ? "إعداد ملفك الشخصي"
      : (isFrench ? "Configurer votre profil" : "Setup Your Profile");

  String get BaicInfo => isArabic
      ? "معلومات عامة"
      : (isFrench ? "Informations de base" : "Basic Information");

  // Price Range (DZD)
  String get priceRange =>
      isArabic ? "حدود السعر " : (isFrench ? "Plage de prix" : "Price Range");

  // DZD
  String get dzd => isArabic ? "دج" : (isFrench ? "DZD" : "DZD");

  // Minimum Rating
  String get minimumRating => isArabic
      ? "التقييم الأدنى"
      : (isFrench ? "Note minimale" : "Minimum Rating");

  // Manual Verification
  String get manualVerificationTitle => isArabic
      ? "التحقق اليدوي"
      : (isFrench ? "Vérification manuelle" : "Manual Verification");
  // Please provide clear photos of your ID and face for verification
  String get manualVerificationDescription => isArabic
      ? "يرجى تقديم صور واضحة لهويتك ووجهك للتحقق"
      : (isFrench
          ? "Veuillez fournir des photos claires de votre pièce d'identité et de votre visage pour vérification"
          : "Please provide clear photos of your ID and face for verification");

  // ID Document
  String get idDocument => isArabic
      ? "وثيقة الهوية"
      : (isFrench ? "Document d'identité" : "ID Document");

  // Upload a clear photo of your government-issued ID
  String get idDocumentDescription => isArabic
      ? "قم بتحميل صورة واضحة لهويتك الصادرة عن الحكومة"
      : (isFrench
          ? "Téléchargez une photo claire de votre pièce d'identité délivrée par le gouvernement"
          : "Upload a clear photo of your government-issued ID");
  // Selfie Photo
  String get selfiePhoto =>
      isArabic ? "صورة شخصية" : (isFrench ? "Photo de soi" : "Selfie Photo");

  // Take a clear photo of your face
  String get selfiePhotoDescription => isArabic
      ? "التقط صورة واضحة لوجهك"
      : (isFrench
          ? "Prenez une photo claire de votre visage"
          : "Take a clear photo of your face");
  // No image selected
  String get noImageSelected => isArabic
      ? "لم يتم اختيار صورة"
      : (isFrench ? "Aucune image sélectionnée" : "No image selected");
  // Camera
  String get camera => isArabic ? "الكاميرا" : (isFrench ? "Caméra" : "Camera");
  // Gallery
  String get gallery =>
      isArabic ? "المعرض" : (isFrench ? "Galerie" : "Gallery");
  // Submit for Verification
  String get submitForVerification => isArabic
      ? "إرسال للتحقق"
      : (isFrench ? "Soumettre pour vérification" : "Submit for Verification");
  // Verification request sent successfully
  String get verificationRequestSent => isArabic
      ? "تم إرسال طلب التحقق بنجاح"
      : (isFrench
          ? "Demande de vérification envoyée avec succès"
          : "Verification request sent successfully");
  // "eg. 2018"
  String get egFrom =>
      isArabic ? "مثال: 2018" : (isFrench ? "par exemple: 2018" : "eg: 2018");
  String get egTo =>
      isArabic ? "مثال: 2024" : (isFrench ? "par exemple: 2024" : "eg: 2024");

  // About HANINI
  String get aboutHanini => isArabic
      ? "حول هنيني"
      : (isFrench ? "À propos de Hanini" : "About Hanini");
  // HANINI is your ultimate platform for connecting with service providers in Algeria. From household repairs to professional consultations, HANINI simplifies finding the right person for the job.
  String get aboutHaniniDescription => isArabic
      ? "هنيني هو منصتك النهائية للتواصل مع مقدمي الخدمات في الجزائر. من إصلاحات المنزل إلى الاستشارات المهنية، يبسط هنيني العثور على الشخص المناسب للعمل."
      : (isFrench
          ? "HANINI est votre plateforme ultime pour vous connecter avec des prestataires de services en Algérie. Des réparations domestiques aux consultations professionnelles, HANINI simplifie la recherche de la bonne personne pour le travail."
          : "HANINI is your ultimate platform for connecting with service providers in Algeria. From household repairs to professional consultations, HANINI simplifies finding the right person for the job.");
  // Our Mission
  String get ourMission =>
      isArabic ? "مهمتنا" : (isFrench ? "Notre mission" : "Our Mission");
  // Our mission is to provide a reliable platform for connecting service providers with customers. We aim to simplify the process of finding the right person for the job.
  String get ourMissionDescription => isArabic
      ? "مهمتنا هي توفير منصة موثوقة لربط مقدمي الخدمات بالعملاء. نهدف إلى تبسيط عملية العثور على الشخص المناسب للعمل."
      : (isFrench
          ? "Notre mission est de fournir une plateforme fiable pour connecter les prestataires de services avec les clients. Nous visons à simplifier le processus de recherche de la bonne personne pour le travail."
          : "Our mission is to provide a reliable platform for connecting service providers with customers. We aim to simplify the process of finding the right person for the job.");
  // Key Features
  String get keyFeatures => isArabic
      ? "الميزات الرئيسية"
      : (isFrench ? "Caractéristiques clés" : "Key Features");

  // AI-based identity verification for secure connections
  String get aiBasedVerification => isArabic
      ? "التحقق من الهوية بناءً على الذكاء الاصطناعي للاتصالات الآمنة"
      : (isFrench
          ? "Vérification d'identité basée sur l'IA pour des connexions sécurisées"
          : "AI-based identity verification for secure connections");
  // Personalized recommendations tailored to your needs
  String get personalizedRecommendations => isArabic
      ? "توصيات شخصية مصممة خصيصًا لاحتياجاتك"
      : (isFrench
          ? "Recommandations personnalisées adaptées à vos besoins"
          : "Personalized recommendations tailored to your needs");
  // Transparent reviews and ratings to help you choose wisely
  String get transparentReviews => isArabic
      ? "مراجعات وتقييمات شفافة لمساعدتك في اختيار بحكمة"
      : (isFrench
          ? "Avis et évaluations transparents pour vous aider à choisir judicieusement"
          : "Transparent reviews and ratings to help you choose wisely");
  // Premium subscriptions and targeted ads for providers
  String get premiumSubscriptions => isArabic
      ? "اشتراكات مميزة وإعلانات مستهدفة لمقدمي الخدمات"
      : (isFrench
          ? "Abonnements premium et publicités ciblées pour les fournisseurs"
          : "Premium subscriptions and targeted ads for providers");

  // Why Choose HANINI ?
  String get whyChooseHanini => isArabic
      ? "لماذا تختار هنيني؟"
      : (isFrench ? "Pourquoi choisir Hanini ?" : "Why Choose Hanini ?");
  // We bring convenience, trust, and efficiency to your doorstep. Our user-friendly platform ensures that connecting with the right service provider is just a few taps away.
  String get whyChooseHaniniDescription => isArabic
      ? "نوفر الراحة والثقة والكفاءة إلى عتبة بابك. تضمن منصتنا السهلة الاستخدام أن الاتصال بمقدم الخدمة المناسب على بعد بضع نقرات."
      : (isFrench
          ? "Nous apportons la commodité, la confiance et l'efficacité à votre porte. Notre plateforme conviviale garantit que se connecter avec le bon prestataire de services n'est qu'à quelques clics."
          : "We bring convenience, trust, and efficiency to your doorstep. Our user-friendly platform ensures that connecting with the right service provider is just a few taps away.");
  // Get in Touch
  String get getInTouch =>
      isArabic ? "تواصل معنا" : (isFrench ? "Contactez-nous" : "Get in Touch");

  // Have questions or feedback? Reach out to us at support@hanini.com. We are always here to help!
  String get getInTouchDescription => isArabic
      ? "هل لديك أسئلة أو تعليقات؟ تواصل معنا على support@hanini.com. نحن دائمًا هنا للمساعدة!"
      : (isFrench
          ? "Vous avez des questions ou des commentaires ? Contactez-nous à support@hanini.com. Nous sommes toujours là pour vous aider !"
          : "Have questions or feedback? Reach out to us at support@hanini.com. We are always here to help!");

  // Back to Home
  String get backToHome => isArabic
      ? "العودة إلى الصفحة الرئيسية"
      : (isFrench ? "Retour à l'accueil" : "Back to Home");

  // You are signed in with
  String get signedInWith => isArabic
      ? "أنت مسجل باستخدام"
      : (isFrench ? "Vous êtes connecté avec" : "You're signed in with");

  // Facebook
  String get facebook =>
      isArabic ? '" فيسبوك "' : (isFrench ? "Facebook" : "Facebook");
  // Apple
  String get apple => isArabic ? '" أبل "' : (isFrench ? '" Apple "' : "Apple");
  // Google
  String get google => isArabic ? '" جوجل "' : (isFrench ? "Google" : "Google");

  // Please visit
  String get pleaseVisit => isArabic
      ? "يرجى زيارة إعدادت"
      : (isFrench ? "Veuillez visiter" : "Please visit");

  // settings to manage your password.
  String get settingsToManagePassword => isArabic
      ? "لإدارة كلمة المرور الخاصة بك."
      : (isFrench
          ? "paramètres pour gérer votre mot de passe."
          : "settings to manage your password.");

  // Current Password
  String get currentPassword => isArabic
      ? "كلمة المرور الحالية"
      : (isFrench ? "Mot de passe actuel" : "Current Password");

  // Please enter your current password
  String get currentPasswordRequiredError => isArabic
      ? "الرجاء إدخال كلمة المرور الحالية"
      : (isFrench
          ? "Veuillez entrer votre mot de passe actuel"
          : "Please enter your current password");

  // New Password
  String get newPassword => isArabic
      ? "كلمة المرور الجديدة"
      : (isFrench ? "Nouveau mot de passe" : "New Password");

  // Please enter a new password
  String get newPasswordRequiredError => isArabic
      ? "الرجاء إدخال كلمة مرور جديدة"
      : (isFrench
          ? "Veuillez entrer un nouveau mot de passe"
          : "Please enter a new password");

  // Confirm New Password
  String get confirmNewPassword => isArabic
      ? "تأكيد كلمة المرور الجديدة"
      : (isFrench
          ? "Confirmer le nouveau mot de passe"
          : "Confirm New Password");

  // Please confirm your new password
  String get confirmNewPasswordRequiredError => isArabic
      ? "يرجى تأكيد كلمة المرور الجديدة"
      : (isFrench
          ? "Veuillez confirmer votre nouveau mot de passe"
          : "Please confirm your new password");

  // Static method to access the instance
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Privacy Settings
  String get privacyInfo => isArabic
      ? "معلومات الخصوصية"
      : (isFrench ? "Info Sur confidentialité" : "Privacy Info");

  // Privacy Policy
  String get privacyPolicy => isArabic
      ? "سياسة الخصوصية"
      : (isFrench ? "Politique de confidentialité" : "Privacy Policy");
  // Welcome to HANINI! Your privacy is important to us. This page outlines how we collect, use, and protect your information.
  String get privacyPolicyDescription => isArabic
      ? "مرحبًا بك في هنيني! تهم خصوصيتك بالنسبة لنا. توضح هذه الصفحة كيفية جمعنا واستخدامنا وحماية معلوماتك."
      : (isFrench
          ? "Bienvenue sur HANINI! Votre vie privée est importante pour nous. Cette page décrit comment nous collectons, utilisons et protégeons vos informations."
          : "Welcome to HANINI! Your privacy is important to us. This page outlines how we collect, use, and protect your information.");

  // Information We Collect
  String get informationWeCollect => isArabic
      ? "المعلومات التي نجمعها"
      : (isFrench
          ? "Informations que nous collectons"
          : "Information We Collect");

  // We may collect personal information such as your name, email address, location, and payment details to provide better services.
  String get informationWeCollectDescription => isArabic
      ? " قد نجمع معلومات شخصية مثل اسمك وعنوان بريدك الإلكتروني وموقعك وتفاصيل الدفع لتقديم خدمات أفضل."
      : (isFrench
          ? "Nous pouvons collecter des informations personnelles telles que votre nom, votre adresse e-mail, votre emplacement et vos détails de paiement pour fournir de meilleurs services."
          : "We may collect personal information such as your name, email address, location, and payment details to provide better services.");

  //  How We Use Your Information
  String get howWeUseYourInformation => isArabic
      ? "كيف نستخدم معلوماتك"
      : (isFrench
          ? "Comment nous utilisons vos informations"
          : "How We Use Your Information");
  //  Your data is used to connect you with service providers, enhance your experience, and for app analytics to improve our services.
  String get howWeUseYourInformationDescription => isArabic
      ? "تُستخدم بياناتك لربطك بمقدمي الخدمات وتعزيز تجربتك ولتحليلات التطبيق لتحسين خدماتنا."
      : (isFrench
          ? "Vos données sont utilisées pour vous connecter avec des prestataires de services, améliorer votre expérience et pour les analyses de l'application afin d'améliorer nos services."
          : "Your data is used to connect you with service providers, enhance your experience, and for app analytics to improve our services.");
  //  Data Protection
  String get dataProtection => isArabic
      ? "حماية البيانات"
      : (isFrench ? "Protection des données" : "Data Protection");
  //  We implement strict measures to protect your information from unauthorized access, alteration, or deletion.
  String get dataProtectionDescription => isArabic
      ? "نقوم بتنفيذ تدابير صارمة لحماية معلوماتك من الوصول غير المصرح به أو التغيير أو الحذف."
      : (isFrench
          ? "Nous mettons en œuvre des mesures strictes pour protéger vos informations contre tout accès, altération ou suppression non autorisés."
          : "We implement strict measures to protect your information from unauthorized access, alteration, or deletion.");
  //  Sharing Your Information
  String get sharingYourInformation => isArabic
      ? "مشاركة معلوماتك"
      : (isFrench ? "Partage de vos informations" : "Sharing Your Information");
  //  We do not sell your information. We may share data with third-party services necessary for running the app, following privacy standards.
  String get sharingYourInformationDescription => isArabic
      ? "نحن لا نبيع معلوماتك. قد نشارك البيانات مع خدمات الطرف الثالث الضرورية لتشغيل التطبيق، وفقًا لمعايير الخصوصية."
      : (isFrench
          ? "Nous ne vendons pas vos informations. Nous pouvons partager des données avec des services tiers nécessaires au fonctionnement de l'application, suivant les normes de confidentialité."
          : "We do not sell your information. We may share data with third-party services necessary for running the app, following privacy standards.");
  //  Your Rights
  String get yourRights =>
      isArabic ? "حقوقك" : (isFrench ? "Vos droits" : "Your Rights");
  //  You have the right to access, modify, or request deletion of your data. Contact us at support@hanini.com for any concerns.
  String get yourRightsDescription => isArabic
      ? "لديك الحق في الوصول إلى بياناتك وتعديلها أو طلب حذفها. اتصل بنا على support@hanini.com لأي مخاوف."
      : (isFrench
          ? "Vous avez le droit d'accéder à vos données, de les modifier ou de demander leur suppression. Contactez-nous à support@hanini.com pour toute préoccupation."
          : "You have the right to access, modify, or request deletion of your data. Contact us at support@hanini.com for any concerns.");
  //  Updates to this Policy
  String get updatesToThisPolicy => isArabic
      ? "تحديثات لهذه السياسة"
      : (isFrench
          ? "Mises à jour de cette politique"
          : "Updates to this Policy");
  //  We may update this policy occasionally. Please check this page regularly for updates.
  String get updatesToThisPolicyDescription => isArabic
      ? "قد نقوم بتحديث هذه السياسة بين الحين والآخر. يرجى التحقق من هذه الصفحة بانتظام للحصول على التحديثات."
      : (isFrench
          ? "Nous pouvons mettre à jour cette politique de temps en temps. Veuillez consulter cette page régulièrement pour les mises à jour."
          : "We may update this policy occasionally. Please check this page regularly for updates.");

  static void load(Locale newLocale) {}
}

// Delegate class to handle localization
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Create and return an instance of AppLocalizations with the current locale
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
