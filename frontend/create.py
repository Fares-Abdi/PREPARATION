import os

# Define the directory structure
structure = {
    "hanini-frontend": [
        "lib/",
        "lib/screens/",
        "lib/screens/onboarding/",
        "lib/screens/auth/",
        "lib/screens/home/",
        "lib/screens/profile/",
        "lib/screens/verification/",
        "lib/models/",
        "lib/services/",
        "lib/widgets/",
        "lib/utils/",
        "lib/config/",
        "lib/themes/",
        "lib/localization/",
        "assets/images/",
        "assets/icons/",
        "assets/fonts/"
    ],
    "hanini-frontend/lib": [
        "main.dart",
        "routes.dart"
    ],
    "hanini-frontend/lib/screens/onboarding": ["onboarding_screen.dart"],
    "hanini-frontend/lib/screens/auth": ["login_screen.dart", "signup_screen.dart"],
    "hanini-frontend/lib/screens/home": ["home_screen.dart"],
    "hanini-frontend/lib/screens/profile": ["profile_screen.dart"],
    "hanini-frontend/lib/screens/verification": ["id_verification_screen.dart", "face_verification_screen.dart"],
    "hanini-frontend/lib/models": ["user.dart", "service.dart", "booking.dart"],
    "hanini-frontend/lib/services": ["auth_service.dart", "api_service.dart"],
    "hanini-frontend/lib/widgets": ["custom_button.dart", "custom_text_field.dart"],
    "hanini-frontend/lib/utils": ["constants.dart", "helpers.dart"],
    "hanini-frontend/lib/config": ["app_config.dart"],
    "hanini-frontend/lib/themes": ["app_theme.dart"],
    "hanini-frontend/lib/localization": ["app_localization.dart"],
    "hanini-frontend/assets": [
        "pubspec.yaml"
    ]
}


# Function to create files and directories
def create_structure(base_path, structure):
    for name, content in structure.items():
        path = os.path.join(base_path, name)

        # If content is a list, create files and directories in it
        if isinstance(content, list):
            os.makedirs(path, exist_ok=True)
            for item in content:
                item_path = os.path.join(path, item)
                if '.' in item:  # It's a file
                    with open(item_path, 'w') as f:
                        f.write(f"// {item}")  # Write a placeholder in each file
                        print(f"Created file: {item_path}")
                else:  # It's a directory
                    os.makedirs(item_path, exist_ok=True)
                    print(f"Created directory: {item_path}")

        # If content is a dictionary, go deeper
        elif isinstance(content, dict):
            os.makedirs(path, exist_ok=True)
            print(f"Created directory: {path}")
            create_structure(path, content)


# Run the script
create_structure(".", structure)
