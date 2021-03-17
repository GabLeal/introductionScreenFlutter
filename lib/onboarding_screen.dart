import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introScreenFlutter/new_page_model.dart';

class OnboardingScreen extends StatefulWidget {
  final List<NewPageViewModel> pages;
  final Function isDone;
  final Function isSkip;
  OnboardingScreen({this.pages, this.isDone, this.isSkip});
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator(int numPages) {
    List<Widget> list = [];
    for (int i = 0; i < numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 10.0,
      width: isActive ? 18.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xff022346) : Colors.grey[800].withOpacity(0.6),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  TextStyle _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 26.0,
    height: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.hashCode * 0.7,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: widget.pages.map((pageModel) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          pageModel.header,
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 18),
                                      child: pageModel.title,
                                    ),
                                    pageModel.body
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              _currentPage != widget.pages.length - 1
                  ? Container(
                      padding: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                              onPressed: () {
                                _pageController.animateToPage(
                                    widget.pages.length,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.ease);
                              },
                              child: Text('pular')),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  _buildPageIndicator(widget.pages.length),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Icon(
                              Icons.arrow_forward,
                              color: Color(0xff022346),
                              size: 30.0,
                            ),
                          )
                        ],
                      ))
                  : Text(''),
            ],
          ),
        ),
      ),
      bottomSheet: _currentPage == widget.pages.length - 1
          ? Material(
              elevation: 10,
              color: Color(0xff022346),
              child: Container(
                height: 100.0,
                width: double.infinity,
                child: InkWell(
                  splashColor: Colors.black.withOpacity(0.3),
                  onTap: widget.isDone,
                  child: Center(
                    child: Text(
                      'Vamos começar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
