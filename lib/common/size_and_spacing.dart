class SizeAndSpacing {
  //Threshholds 

  //Design Spec Dimensions
  //widths
  double desktopWidth = 1728;
  double tabletWidth = 1024;
  double mobileWidth = 390;


  //heights
  double desktopHeight = 1117; //to change
  double tabletHeight = 1366; //to change
  double mobileHeight = 844; 
  String fontFamily = "DM Sans";


  String _screenType (double screenWidth) {
    if (screenWidth <600) {
      return "mobile";
    } else if (screenWidth < 1200) {
      return "tablet";
    } else {
      return "desktop";
    }
  }

  //conditionals
  bool isDesktop(double screenWidth) => _screenType(screenWidth) == "desktop";

  bool isTablet(double screenWidth) => _screenType(screenWidth) == "tablet";

  bool isMobile(double screenWidth) => _screenType(screenWidth) == "mobile";

  double getWidth(double elementWidth, double screenWidth) {
    if (isDesktop(screenWidth)) {
      
      return elementWidth * (screenWidth / desktopWidth);
    } else if (isTablet(screenWidth)) {
    
      return elementWidth * (screenWidth / tabletWidth);
    } else {
      return elementWidth * (screenWidth / mobileWidth);
    }
  }

  double getHeight(
      double elementHeight, double screenHeight, double screenWidth) {
    if (isDesktop(screenWidth)) {
      return elementHeight * (screenHeight / desktopHeight);
    } else if (isTablet(screenWidth)) {
      return elementHeight * (screenHeight / tabletHeight);
    } else {
      return elementHeight * (screenHeight / mobileHeight);
    }
  }

  double getFontSize(double fontSize, double screenWidth) {
    if (isDesktop(screenWidth)) {
      return fontSize * (screenWidth / desktopWidth);
    } else if (isTablet(screenWidth)) {
      return fontSize * (screenWidth / tabletWidth);
    } else {
      return fontSize * (screenWidth / mobileWidth);
    }
  }
}
