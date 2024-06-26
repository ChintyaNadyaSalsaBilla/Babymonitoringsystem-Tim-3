import 'package:babymonitoringsystem/cloud.dart';
import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(pages: [
        OnboardingPageModel(
          imageUrl: 'assets/ob1.png',
        ),
        OnboardingPageModel(
          imageUrl: 'assets/ob2.png',
        ),
        OnboardingPageModel(
          imageUrl: 'assets/ob3.png',
        ),
      ]),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter({
    Key? key,
    required this.pages,
    this.onSkip,
    this.onFinish,
  }) : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  // Store the currently visible page
  int _currentPage = 0;
  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                // Pageview to render each page
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    // Change current page when pageview changes
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(item.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Empty Row to push the content to the bottom
                            Row(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      widget.onSkip?.call();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CloudStoragePage()),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 64, 84, 112)
                                              .withOpacity(0.5),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 20),
                                    ),
                                    child: const Text(
                                      'Skip',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (_currentPage < widget.pages.length - 1)
                                    TextButton(
                                      onPressed: () {
                                        _pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 250),
                                          curve: Curves.easeInOutCubic,
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 64, 84, 112)
                                                .withOpacity(0.5),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 20),
                                      ),
                                      child: const Text(
                                        'Next',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  if (_currentPage == widget.pages.length - 1)
                                    TextButton(
                                      onPressed: () {
                                        widget.onFinish?.call();
                                        // Navigate to the desired route upon finishing
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CloudStoragePage()),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 64, 84, 112)
                                                .withOpacity(0.5),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 20),
                                      ),
                                      child: const Text(
                                        'Finish',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  final String imageUrl;

  OnboardingPageModel({
    required this.imageUrl,
  });
}
