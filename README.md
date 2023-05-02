# face_rekog

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

### Recognizing faces just got easier with Face Rekog!
<br>

### Outputs

<div align=center>
<img src="./before-adding-rick.jpeg" width=200 height=300 alt="before-adding-rick">
<img src="./after-adding-rick.jpeg" width=200 height=300 alt="after-adding-rick">
<img src="./no-face.jpeg" width=200 height=300 alt="no-face">

</div>
1 Before adding rick's face to DB <br>
2 After adding rick's face to DB <br>
3 If there are no faces in the image

<br>
<br>

## How to run?
- Run `flutter pub get` in the root folder
- in the root folder, create a `.env` file with the following contents:
```.env
ACCESSKEY=<your_aws_access_key_here>
SECRETKEY=<your_aws_secret_key_here>
```
- run `flutter pub run build_runner build` in root folder, this will generate an `env.g.dart` in the root/env 
- run `flutter run` to run the app.
<br>


# Features to be implemented

- [x] Creating a SignUp Page
- [x] Modifying Login/Signup
- [x] change ui according to device sizes
- [ ] create an onboarding screen
- [ ] testing
- [ ] user should automatically be logged in after registering with a new id
- [ ] Google sign-in
- [ ] Fix the login issue
- [ ] Change textbutton on register screen
 
### Features

- [x] Add faces to database
- [x] Scan faces and look into database if the face exists
- [x] Return the name of the face
- [x] If a face is added that is already in the db, then the new face will be stored with the original name.
