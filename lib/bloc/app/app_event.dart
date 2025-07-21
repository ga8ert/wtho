abstract class AppEvent {}

class AppStarted extends AppEvent {}

class AppLoggedIn extends AppEvent {}

class AppLoggedOut extends AppEvent {}

class AppProfileOpened extends AppEvent {}

class AppBackToHomeRequested extends AppEvent {}
