class OnboardingData {
  final String title;
  final String description;
  final String lottieAsset;
  final String? imageAsset;

  OnboardingData({
    required this.title,
    required this.description,
    required this.lottieAsset,
    this.imageAsset,
  });

  static List<OnboardingData> getOnboardingData() {
    return [
      OnboardingData(
        title: "Bienvenue dans votre Portail Étudiant",
        description:
            "Accédez facilement à vos bulletins, notes et informations académiques en un seul endroit.",
        lottieAsset: "assets/animations/welcome_education.json",
      ),
      OnboardingData(
        title: "Suivi en Temps Réel",
        description:
            "Consultez vos notes, moyennes et classements dès leur publication par vos professeurs.",
        lottieAsset: "assets/animations/student_background.json",
      ),
      OnboardingData(
        title: "Communication Simplifiée",
        description:
            "Recevez des notifications importantes et communiquez facilement avec votre établissement.",
        lottieAsset: "assets/animations/communication.json",
      ),
      OnboardingData(
        title: "Accès Parent-Élève",
        description:
            "Parents et élèves peuvent accéder aux informations académiques de manière sécurisée.",
        lottieAsset: "assets/animations/family_education.json",
      ),
    ];
  }
}
