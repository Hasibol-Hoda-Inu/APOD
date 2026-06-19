import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Astronomy Picture of the Day",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          Text(
            "Discover the cosmos! Each day a different image or photograph of our fascinating universe is featured, along with a brief explanation written by a professional astronomer.",
            textAlign: TextAlign.center,
          ),
          Text("2026 June 8"),
          Image.network(
            "https://apod.nasa.gov/apod/image/2606/R3Tails_Kurak_960.jpg",
          ),
          Text("Comet R3 PanSTARRS Through Time"),
          Text(
            "Image Credit & Copyright: Jakub Kuřák & Martin Mašek (FZU of the Czech Academy of Sciences)",
            textAlign: TextAlign.center,
          ),
          Text.rich(
              TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black
                ),
                text: "Explanation:",
                children: <TextSpan>[
                  TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.normal
                    ),
                    text: '''What happens to a comet as it leaves our inner Solar System? Now, the arrival of a comet into the inner Solar System is typically heralded with great fanfare and high hopes that the comet will become bright and photogenic. But on the way out, the comet's nucleus is less warmed by the Sun, less gas and dust are expelled, the bright coma around the nucleus shrinks and fades, and the tail length drops off. Many comets will then return to the outer Solar System and only return in hundreds or thousands of years. In contrast, some comets -- like Comet C/2025 R3 (PanSTARRS) -- receive a gravitational kick from the planets and so will never return. Pictured, Comet R3 PanSTARRs was imaged deeply many nights in early to mid-May near Cerro Paranal in Chile. Later images appear closer to the top and clearly show the shrinking ion tail. '''
                  ),
                ]
              ),
          ),
        ],
      ),
    );
  }
}
