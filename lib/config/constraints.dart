class ConfigConstraints {
  static bool isMobile(double pixels) => pixels <= 500;
  static double maxSideBarWidth(double pixels) => isMobile(pixels)
      ? pixels
      : pixels * 0.4 > 360
          ? 360
          : pixels * 0.4;
}
