import 'dart:async';

import 'package:alertus/core/components/buttons/primary_button.dart';
import 'package:alertus/core/components/textfields/primary_text_field.dart';
import 'package:alertus/core/constants/router.dart';
import 'package:alertus/core/resources/colors.dart';
import 'package:alertus/core/resources/images.dart';
import 'package:alertus/core/resources/svg.dart';
import 'package:alertus/core/styles/textfieldstyle.dart';
import 'package:alertus/core/styles/textstyles/gilroy_font_black.dart';
import 'package:alertus/core/styles/textstyles/gilroy_font_custom.dart';
import 'package:alertus/core/styles/textstyles/gilroy_font_white.dart';
import 'package:alertus/core/widgets/touchable_opacity_widget.dart';
import 'package:alertus/widgets/fake_call.dart';
import 'package:alertus/widgets/sos.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  late bool isFakeCall = false;
  late bool isSOS = false;
  int seconds = 0;
  final player = AudioPlayer();
  late Timer timer;

  late List<Widget> tabs = [
    HomeTab(
      onFakeCall: () async {
        seconds = 0;

        await player.play(AssetSource('lotties/fakecall.mp3'));
        setState(() {
          isFakeCall = true;
        });
      },
      onSOS: () {
        setState(() {
          isSOS = true;
        });
      },
    ),
    MapsTab(),
    ContactTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlay();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(AssetImage(BaseImages.sosGreen), context);
    precacheImage(AssetImage(BaseImages.sos), context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    stop();
    timer.cancel();
    super.dispose();
  }

  void stop() async {
    await player.stop();
  }

  void initPlay() async {
    await player.setSource(AssetSource('lotties/fakecall.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: tabs[index],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 17.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 22,
                        offset: const Offset(0, -18),
                        color: const Color(0xFFA39CB1).withOpacity(.06),
                      )
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TouchableOpacityWidget(
                          onTap: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                BaseSvg.icHome,
                                height: 30.w,
                                color: index == 0
                                    ? BaseColors.primaryLightOrange
                                    : null,
                              ),
                              SizedBox(height: 9.w),
                              Text(
                                "Home",
                                style: GilreyFont.medium12(context).copyWith(
                                  color: index == 0
                                      ? BaseColors.primaryLightOrange
                                      : const Color(0xFFBABEC1),
                                ),
                              )
                            ],
                          ),
                        ),
                        TouchableOpacityWidget(
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                BaseSvg.icMaps,
                                height: 20.w,
                                color: index == 1
                                    ? BaseColors.primaryLightOrange
                                    : null,
                              ),
                              SizedBox(height: 11.w),
                              Text(
                                "Maps",
                                style: GilreyFont.medium12(context).copyWith(
                                  color: index == 1
                                      ? BaseColors.primaryLightOrange
                                      : const Color(0xFFBABEC1),
                                ),
                              )
                            ],
                          ),
                        ),
                        TouchableOpacityWidget(
                          onTap: () {
                            setState(() {
                              index = 2;
                            });
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                BaseSvg.icPhone,
                                color: index == 2
                                    ? BaseColors.primaryLightOrange
                                    : null,
                              ),
                              SizedBox(height: 9.w),
                              Text(
                                "Phone",
                                style: GilreyFont.medium12(context).copyWith(
                                  color: index == 2
                                      ? BaseColors.primaryLightOrange
                                      : const Color(0xFFBABEC1),
                                ),
                              )
                            ],
                          ),
                        ),
                        TouchableOpacityWidget(
                          onTap: () {
                            setState(() {
                              index = 3;
                            });
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                BaseSvg.icUser,
                                color: index == 3
                                    ? BaseColors.primaryLightOrange
                                    : null,
                              ),
                              SizedBox(height: 9.w),
                              Text(
                                "Profile",
                                style: GilreyFont.medium12(context).copyWith(
                                  color: index == 3
                                      ? BaseColors.primaryLightOrange
                                      : const Color(0xFFBABEC1),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isFakeCall
              ? StreamBuilder<int>(
                  stream: Stream.periodic(Duration(seconds: 1), (i) => seconds),
                  builder: (context, snapshot) {
                    var formattedTime = "00:00";
                    if (!snapshot.hasData) {
                      final int totalSeconds = seconds;
                      final int minutes = totalSeconds ~/ 60;
                      final int remainingSeconds = totalSeconds % 60;

                      // Format waktu ke format hh:mm
                      formattedTime =
                          '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
                    } else {
                      formattedTime = "00:00";
                    }

                    return FakeCall(
                      minute: formattedTime,
                      onTap: () async {
                        await player.stop();

                        setState(() {
                          isFakeCall = false;
                          seconds = 0;
                        });
                      },
                    );
                  })
              : Container(),
          isSOS
              ? SOS(
                  onTap: () {
                    setState(() {
                      isSOS = false;
                    });
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}

class MapsTab extends StatefulWidget {
  MapsTab({
    super.key,
  });

  @override
  State<MapsTab> createState() => _MapsTabState();
}

class _MapsTabState extends State<MapsTab> {
  final TransformationController _controller = TransformationController(
    Matrix4.identity().scaled(1.2),
  );

  bool isDangerious = false;
  bool isLocation = true;
  bool police = false;
  bool fire = false;

  @override
  void initState() {
    super.initState();
  }

  String getImage() {
    if (police) {
      if (isDangerious) {
        return BaseImages.googleMaps2Danger;
      } else {
        return BaseImages.googleMaps2;
      }
    } else if (fire) {
      if (isDangerious) {
        return BaseImages.mapsFireDanger;
      } else {
        return BaseImages.mapsFire;
      }
    } else {
      if (isDangerious) {
        return BaseImages.googleMapsDanger;
      } else {
        return BaseImages.googleMaps;
      }
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return BaseColors.primaryLightOrange;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          transformationController: _controller,
          minScale: 5,
          maxScale: 10,
          child: Container(
            color: Colors.amber,
            width: double.infinity,
            child: Image.asset(
              getImage(),
              fit: BoxFit.cover,
            ),
          ),
        ),
        isLocation == false
            ? SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20.w),
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: BaseColors.fontPrimaryLightOrange,
                              width: 3,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 7.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Maps Feature",
                                style: GilroyFontBlack.bold10(context),
                              ),
                              SizedBox(height: 8.w),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: Checkbox(
                                      checkColor:
                                          BaseColors.fontPrimaryLightOrange,
                                      value: isDangerious,
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              getColor),
                                      onChanged: (value) {
                                        setState(() {
                                          isDangerious = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Show dangerious locations",
                                    style: GilroyFontBlack.medium10(context),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: isDangerious,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5.w),
                                    Row(
                                      children: [
                                        SizedBox(width: 40.w),
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color(0xFFFF0000),
                                          radius: 6.w,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "Dangerious Locations",
                                          style:
                                              GilroyFontBlack.medium10(context),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.w),
                                    Row(
                                      children: [
                                        SizedBox(width: 40.w),
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color(0xFF00C920),
                                          radius: 6.w,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "Safe Locations",
                                          style:
                                              GilroyFontBlack.medium10(context),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.w),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 33.w),
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
        isLocation == false
            ? SafeArea(
                child: Column(
                  children: [
                    const Spacer(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 20.w),
                          Row(
                            children: [
                              TouchableOpacityWidget(
                                onTap: () {
                                  setState(() {
                                    police = !police;
                                    if (fire) {
                                      fire = false;
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: police
                                        ? BaseColors.fontPrimaryLightOrange
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      color: BaseColors.primaryLightOrange,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                    vertical: 13.h,
                                  ),
                                  child: Text(
                                    "Police Station",
                                    style: GilroyFontBlack.bold12(context)
                                        .copyWith(
                                      color: police
                                          ? Colors.white
                                          : BaseColors.fontPrimaryBlack,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                            ],
                          ),
                          Row(
                            children: [
                              TouchableOpacityWidget(
                                onTap: () {
                                  setState(() {
                                    fire = !fire;
                                    if (police) {
                                      police = false;
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: fire
                                        ? BaseColors.fontPrimaryLightOrange
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      color: BaseColors.primaryLightOrange,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                    vertical: 13.h,
                                  ),
                                  child: Text(
                                    "Fire Department",
                                    style: GilroyFontBlack.bold12(context)
                                        .copyWith(
                                      color: fire
                                          ? Colors.white
                                          : BaseColors.fontPrimaryBlack,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: BaseColors.primaryLightOrange,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 13.h,
                                ),
                                child: Text(
                                  "Hospital",
                                  style: GilroyFontBlack.bold12(context),
                                ),
                              ),
                              SizedBox(width: 20.w),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: BaseColors.primaryLightOrange,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 13.h,
                                ),
                                child: Text(
                                  "Department",
                                  style: GilroyFontBlack.bold12(context),
                                ),
                              ),
                              SizedBox(width: 20.w),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h),
                  ],
                ),
              )
            : Container(),
        isLocation == true
            ? Stack(
                children: [
                  Container(
                    color: Colors.black.withOpacity(.6),
                  ),
                  SafeArea(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 40.h),
                          Text(
                            "Maps Location",
                            style: GilroyFontBlack.bold30(context).copyWith(
                              color: BaseColors.primaryLightOrange,
                            ),
                          ),
                          Text(
                            "Alert Us",
                            style: GilroyFontBlack.bold18(context).copyWith(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 70.h,
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 45.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 20.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Image.asset(BaseImages.location),
                                SizedBox(height: 20.h),
                                Text(
                                  "Enable your location",
                                  style: GilroyFontBlack.bold24(context),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "Choose your location to start find the request around you",
                                  style: GilroyFontBlack.regular14(context),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 40.h),
                                PrimaryButton(
                                    onTap: () {
                                      setState(() {
                                        isLocation = false;
                                      });
                                    },
                                    text: "Use my location"),
                                SizedBox(height: 20.h),
                                TouchableOpacityWidget(
                                  onTap: () {
                                    setState(() {
                                      isLocation = false;
                                    });
                                  },
                                  child: Text(
                                    "Skip for now",
                                    style:
                                        GilreyFont.medium14(context).copyWith(
                                      color: Color(0xFFB8B8B8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50.h),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({
    super.key,
    required this.onFakeCall,
    required this.onSOS,
  });

  final Function() onFakeCall;
  final Function() onSOS;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool isGreen = false;

  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      BaseImages.overlay,
                    ),
                    alignment: Alignment.topRight,
                  ),
                  color: BaseColors.primaryLightOrange,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 20.w,
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome to the apps",
                                style: GilroyFontWhite.regular20(context),
                              ),
                              Text(
                                "Caecarryo",
                                style: GilroyFontBlack.bold18(context),
                              ),
                            ],
                          ),
                          Image.asset(BaseImages.icNotification),
                        ],
                      ),
                      SizedBox(height: 29.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 11.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            const BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 15,
                              spreadRadius: 0,
                              color: Color(0xFFECF3F6),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(BaseSvg.icSearch),
                                SizedBox(width: 13.w),
                                Text(
                                  "Caecarryo",
                                  style: GilroyFontBlack.regular16(context)
                                      .copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SvgPicture.asset(BaseSvg.icMicrophone),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 36.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Emergency Button",
                          style: GilroyFontBlack.bold18(context),
                        ),
                        TouchableOpacityWidget(
                          onTap: () {
                            Navigator.of(context).pushNamed(ROUTER.setting);
                          },
                          child: Text(
                            "Settings",
                            style: GilroyFontBlack.bold16(context).copyWith(
                              color: BaseColors.primaryLightOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.w),
                    Text(
                      "Are you in emergency?",
                      style: GilroyFontBlack.bold24(context),
                    ),
                    SizedBox(height: 15.w),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      child: Text(
                        "Press the button bellow help will reach you soon.",
                        style: GilroyFontBlack.medium16(context).copyWith(
                          color: BaseColors.borderPrimaryGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    TouchableOpacityWidget(
                      onTap: () async {
                        if (!isGreen) {
                          setState(() {
                            isGreen = true;
                          });
                        } else {
                          widget.onSOS();
                          await Future.delayed(Duration(seconds: 1));
                          setState(() {
                            isGreen = false;
                          });
                        }
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isGreen
                            ? Image.asset(
                                BaseImages.sosGreen,
                                key: ValueKey('1'),
                              )
                            : Image.asset(
                                BaseImages.sos,
                                key: ValueKey('2'),
                              ),
                      ),
                    ),
                    SizedBox(height: 30.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.w,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 15,
                              spreadRadius: 0,
                              color: const Color(0xFFECF3F6).withOpacity(.60),
                            )
                          ]),
                      child: Row(
                        children: [
                          Image.asset(
                            BaseImages.dummyPeople,
                            height: 55.w,
                          ),
                          SizedBox(width: 30.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your current Address",
                                  style: GilroyFontBlack.bold18(context),
                                ),
                                Text(
                                  "Perumahan Permata Buahbatu Bojongsoang Bandung, Jawa barat",
                                  style: GilroyFontBlack.regular12(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.w,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 15,
                              spreadRadius: 0,
                              color: const Color(0xFFECF3F6).withOpacity(.60),
                            )
                          ]),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Fake Call Emergency",
                                  style: GilroyFontBlack.bold18(context),
                                ),
                                TouchableOpacityWidget(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 40.h),
                                          child: Wrap(
                                            spacing: 20,
                                            runSpacing: 20,
                                            children: [
                                              Text(
                                                "Fake Call Emergency",
                                                style: GilroyFontBlack.bold18(
                                                    context),
                                              ),
                                              SizedBox(height: 20.h),
                                              PrimaryTextField(
                                                theme:
                                                    defaultEliteTextFieldTheme(
                                                  context: context,
                                                  borderColor: BaseColors
                                                      .fontPrimaryLightOrange,
                                                ),
                                                readOnly: true,
                                                hintText: "Police Coming",
                                                suffix: SvgPicture.asset(
                                                  BaseSvg.icRadio,
                                                ),
                                              ),
                                              PrimaryTextField(
                                                readOnly: true,
                                                hintText: "Father Calling",
                                                suffix: SvgPicture.asset(
                                                  BaseSvg.icRadio,
                                                ),
                                              ),
                                              Text(
                                                "Add Another Sound",
                                                style:
                                                    GilroyFontBlack.regular14(
                                                        context),
                                              ),
                                              SizedBox(height: 10.h),
                                              SafeArea(
                                                top: false,
                                                child: Column(
                                                  children: [
                                                    PrimaryButton(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        text: "Change Sound"),
                                                    SizedBox(height: 20.h),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Sound : Police Coming",
                                        style:
                                            GilroyFontBlack.regular12(context),
                                      ),
                                      const Icon(Icons.keyboard_arrow_down),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30.w),
                          TouchableOpacityWidget(
                            onTap: () async {
                              widget.onFakeCall();
                            },
                            child: Image.asset(
                              BaseImages.calldring,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 90.w),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ContactTab extends StatelessWidget {
  const ContactTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  BaseImages.overlay,
                ),
                alignment: Alignment.topRight,
              ),
              color: BaseColors.primaryLightOrange,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 20.w,
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11.h),
                            child: Text(
                              "Contact Emergency",
                              style: GilroyFontWhite.regular20(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 29.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 11.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        const BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 15,
                          spreadRadius: 0,
                          color: Color(0xFFECF3F6),
                        )
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(BaseSvg.icSearch),
                            SizedBox(width: 13.w),
                            Text(
                              "Search",
                              style:
                                  GilroyFontBlack.regular16(context).copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(BaseSvg.icMicrophone),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Emergency Button",
                          style: GilroyFontBlack.bold18(context),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Emergency contact number as needed",
                          style: GilroyFontBlack.regular14(context),
                        ),
                      ],
                    ),
                    TouchableOpacityWidget(
                      onTap: () {},
                      child: Text(
                        "View All",
                        style: GilroyFontBlack.bold16(context).copyWith(
                          color: BaseColors.primaryLightOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Card(
                  shape: const RoundedRectangleBorder(),
                  margin: EdgeInsets.zero,
                  shadowColor: const Color(0xFFECF3F6).withOpacity(.06),
                  child: ListTile(
                    leading: Image.asset(BaseImages.logoPolice),
                    title: Text(
                      "Police Office",
                      style: GilroyFontBlack.regular16(context),
                    ),
                    subtitle: Text(
                      "110",
                      style: GilroyFontBlack.regular14(context),
                    ),
                    trailing: const CircleAvatar(
                      backgroundColor: BaseColors.primaryLightGreen,
                      child: Icon(
                        Icons.phone_in_talk_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(),
                  margin: EdgeInsets.zero,
                  shadowColor: const Color(0xFFECF3F6).withOpacity(.06),
                  child: ListTile(
                    leading: Image.asset(BaseImages.logoFirefighter),
                    title: Text(
                      "Fire Department",
                      style: GilroyFontBlack.regular16(context),
                    ),
                    subtitle: Text(
                      "113",
                      style: GilroyFontBlack.regular14(context),
                    ),
                    trailing: const CircleAvatar(
                      backgroundColor: BaseColors.primaryLightGreen,
                      child: Icon(
                        Icons.phone_in_talk_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(),
                  margin: EdgeInsets.zero,
                  shadowColor: const Color(0xFFECF3F6).withOpacity(.06),
                  child: ListTile(
                    leading: Image.asset(BaseImages.logoSar),
                    title: Text(
                      "SAR / Search and Rescue",
                      style: GilroyFontBlack.regular16(context),
                    ),
                    subtitle: Text(
                      "115",
                      style: GilroyFontBlack.regular14(context),
                    ),
                    trailing: const CircleAvatar(
                      backgroundColor: BaseColors.primaryLightGreen,
                      child: Icon(
                        Icons.phone_in_talk_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(),
                  margin: EdgeInsets.zero,
                  shadowColor: const Color(0xFFECF3F6).withOpacity(.06),
                  elevation: 2,
                  child: ListTile(
                    leading: Image.asset(BaseImages.logoHospital),
                    title: Text(
                      "Ambulance",
                      style: GilroyFontBlack.regular16(context),
                    ),
                    subtitle: Text(
                      "118/119",
                      style: GilroyFontBlack.regular14(context),
                    ),
                    trailing: const CircleAvatar(
                      backgroundColor: BaseColors.primaryLightGreen,
                      child: Icon(
                        Icons.phone_in_talk_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 53.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Family Contact",
                          style: GilroyFontBlack.bold18(context),
                        ),
                      ],
                    ),
                    TouchableOpacityWidget(
                      onTap: () {
                        Navigator.of(context).pushNamed(ROUTER.addContact);
                      },
                      child: Text(
                        "Add Contact",
                        style: GilroyFontBlack.bold16(context).copyWith(
                          color: BaseColors.primaryLightOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  "Primary Contact",
                  style: GilroyFontBlack.regular14(context)
                      .copyWith(color: const Color(0xFF939393)),
                ),
                SizedBox(height: 10.h),
                Card(
                  shape: const RoundedRectangleBorder(),
                  margin: EdgeInsets.zero,
                  shadowColor: const Color(0xFFECF3F6).withOpacity(.06),
                  elevation: 2,
                  child: ListTile(
                    leading: Image.asset(BaseImages.doctorMan),
                    title: Text(
                      "Papa",
                      style: GilroyFontBlack.regular16(context),
                    ),
                    subtitle: Text(
                      "081337xxxxx",
                      style: GilroyFontBlack.regular14(context)
                          .copyWith(color: Color(0xFF666666)),
                    ),
                    trailing: const CircleAvatar(
                      backgroundColor: BaseColors.primaryLightGreen,
                      child: Icon(
                        Icons.phone_in_talk_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Call your family",
                  style: GilroyFontBlack.regular14(context)
                      .copyWith(color: const Color(0xFF939393)),
                ),
                SizedBox(height: 10.h),
                Card(
                  shape: const RoundedRectangleBorder(),
                  margin: EdgeInsets.zero,
                  shadowColor: const Color(0xFFECF3F6).withOpacity(.06),
                  elevation: 2,
                  child: ListTile(
                    leading: Image.asset(BaseImages.doctorMan),
                    title: Text(
                      "Uncle",
                      style: GilroyFontBlack.regular16(context),
                    ),
                    subtitle: Text(
                      "081337xxxxx",
                      style: GilroyFontBlack.regular14(context)
                          .copyWith(color: Color(0xFF666666)),
                    ),
                    trailing: const CircleAvatar(
                      backgroundColor: BaseColors.primaryLightGreen,
                      child: Icon(
                        Icons.phone_in_talk_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(),
                  margin: EdgeInsets.zero,
                  shadowColor: const Color(0xFFECF3F6).withOpacity(.06),
                  elevation: 2,
                  child: ListTile(
                    leading: Image.asset(BaseImages.doctorGirl),
                    title: Text(
                      "Mama",
                      style: GilroyFontBlack.regular16(context),
                    ),
                    subtitle: Text(
                      "081337xxxxx",
                      style: GilroyFontBlack.regular14(context)
                          .copyWith(color: Color(0xFF666666)),
                    ),
                    trailing: const CircleAvatar(
                      backgroundColor: BaseColors.primaryLightGreen,
                      child: Icon(
                        Icons.phone_in_talk_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Settings",
                style: GilreyFont.bold24(context)
                    .copyWith(color: BaseColors.primaryLightOrange),
              ),
              SizedBox(height: 2.h),
              Text(
                "General Account",
                style: GilroyFontBlack.regular18(context),
              ),
              SizedBox(height: 53.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Image.asset(
                      BaseImages.dummyPeople,
                      width: 81.w,
                      height: 81.h,
                    ),
                    SizedBox(width: 20.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Caecarryo",
                          style: GilroyFontBlack.bold20(context),
                        ),
                        Text(
                          "Edit Profile",
                          style: GilroyFontBlack.regular14(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              const Divider(
                color: Color(0xFFF5F5F5),
                thickness: 4,
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: SvgPicture.asset(BaseSvg.icBell),
                minLeadingWidth: 24.w,
                title: Text(
                  "Notifications",
                  style: GilroyFontBlack.regular18(context),
                ),
              ),
              ListTile(
                leading: SvgPicture.asset(BaseSvg.icLanguange),
                minLeadingWidth: 24,
                title: Text(
                  "Language",
                  style: GilroyFontBlack.regular18(context),
                ),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: SvgPicture.asset(BaseSvg.icInfo),
                minLeadingWidth: 24,
                title: Text(
                  "F.A.Q",
                  style: GilroyFontBlack.regular18(context),
                ),
              ),
              ListTile(
                leading: SvgPicture.asset(BaseSvg.icRefresh),
                minLeadingWidth: 24,
                title: Text(
                  "About Us",
                  style: GilroyFontBlack.regular18(context),
                ),
              ),
              ListTile(
                leading: SvgPicture.asset(BaseSvg.icMessage),
                minLeadingWidth: 24,
                title: Text(
                  "Message",
                  style: GilroyFontBlack.regular18(context),
                ),
              ),
              const Divider(
                color: Color(0xFFF5F5F5),
                thickness: 4,
              ),
              ListTile(
                leading: SvgPicture.asset(BaseSvg.icLogout),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(ROUTER.login);
                },
                minLeadingWidth: 24,
                title: Text(
                  "Log out",
                  style: GilroyFontBlack.regular18(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
