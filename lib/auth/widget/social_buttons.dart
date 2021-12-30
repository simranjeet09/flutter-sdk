import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontegg/auth/auth_api.dart';
import 'package:frontegg/auth/social_class.dart';
import 'package:frontegg/constants.dart';
import 'package:frontegg/frontegg_user.dart';
import 'package:frontegg/locatization.dart';

class SocialButtons extends StatefulWidget {
  final AuthType type;
  final FronteggUser user;
  const SocialButtons(this.type, this.user, {Key? key}) : super(key: key);

  @override
  _SocialButtonsState createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> {
  List<Social>? socials;
  final AuthApi _api = AuthApi();
  String? socialError;

  checkSocials() async {
    try {
      socials = await _api.checkSocials();
      socialError = null;
    } catch (e) {
      socialError = e.toString();
    }
    setState(() {});
  }

  @override
  void initState() {
    checkSocials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (socials == null) {
      return Container();
    }
    bool oneExist = false;
    for (Social item in socials!) {
      if (item.active ?? false) {
        oneExist = true;
        break;
      }
    }

    return oneExist
        ? Column(
            children: [
              const SizedBox(height: 10),
              Text(
                  '------${tr('or').toUpperCase()} ${widget.type == AuthType.login ? tr('login').toUpperCase() : tr('signup').toUpperCase()} ${tr('with').toUpperCase()}------'),
              const SizedBox(height: 10),
              ...socials!.map((e) => e.active ?? false
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        icon: SvgPicture.asset('asset/${e.type}.svg',
                            package: 'frontegg', width: 30, height: 30, semanticsLabel: 'Acme Logo'),
                        label: Text(
                          e.type != null ? '${e.type![0].toUpperCase()}${e.type!.substring(1)}' : '',
                          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.secondary),
                        ),
                        onPressed: () async {
                          login(e.socialType);
                        },
                      ),
                    )
                  : Container()),
              if (socialError != null)
                Text(
                  socialError!,
                  style: const TextStyle(color: Colors.red),
                )
            ],
          )
        : Container();
  }

  login(SocialType? socType) {
    switch (socType) {
      case SocialType.facebook:
        widget.user.loginOrSignUpFacebook(widget.type);
        break;
      case SocialType.github:
        widget.user.loginOrSignUpGithub(widget.type, context);
        break;
      case SocialType.google:
        widget.user.loginOrSignUpGoogle(widget.type);
        break;
      case SocialType.microsoft:
        widget.user.loginOrSignUpMicrosoft(widget.type);
        break;
      case SocialType.gitlab:
      case SocialType.linkedin:
      default:
        break;
    }
  }
}
