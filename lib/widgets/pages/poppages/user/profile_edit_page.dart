import 'dart:io';
import 'dart:ui';

import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/method_type.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/user_service.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/image.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/invalid_data.dart';
import 'package:groundjp/domain/user/user_profile.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/component/string_validator.dart';
import 'package:groundjp/widgets/component/user_profile_wiget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';


class ProfileEditPage extends ConsumerStatefulWidget {

  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();


}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {

  final int _nicknameMaxLength = 8;
  String? editProfileImagePath;
  late Image? editImage;

  String? _nickname;
  InputBorder? _nicknameBorder;
  TextStyle? _nicknameStyle;

  late TextEditingController _textNicknameController;
  late FocusNode _focusNode;

  bool _sending = false;

  editProfile() async {
    if (_sending) return;
    setState(() {
      _sending = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    Map<String, dynamic> data = {};
    String nickname = _textNicknameController.text;
    if (nickname.isNotEmpty) {
      data.addAll({'nickname' : nickname});
    }

    final result = await ApiService.instance.multipart('/user/edit', method: MethodType.POST, multipartFilePath: editProfileImagePath, data: data);
    if (result.resultCode == ResultCode.OK) {
      ref.read(loginProvider.notifier).readUser(ref);
      if (mounted) {
        Alert.of(context).message(
          message: '프로필이 수정되었습니다.',
          onPressed: () {
            Navigator.pop(context);
          },
        );
      }
    } else if (result.resultCode == ResultCode.INVALID_DATA) {
      _bindingError(InvalidData.fromJson(result.data));
    }

    setState(() {
      _sending = false;
    });
  }

  _bindingError(InvalidData data) {
    if (data.field == 'nickname') {
      _setError(data.message);
    }
  }

  selectImage() async {
    final cropper = await ImagePick.instance.getAndCrop();
    if (cropper != null) {
      setState(() {
        editImage = Image.file(File(cropper.path), fit: BoxFit.contain,);
        editProfileImagePath = cropper.path;
      });
    }
  }

  _distinctCheck() async {
    FocusManager.instance.primaryFocus?.unfocus();
    bool valid = _valid();
    if (!valid) return;
    bool distinct = await UserService.instance.distinctNickname(_textNicknameController.text);
    if (distinct) {
      _setError('이미 사용중인 닉네임 입니다.');
    } else {
      setState(() {
        _nickname = '사용 가능한 닉네임 입니다.';
        _nicknameStyle = TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          color: const Color(0xFF52CA3E),
        );
        _nicknameBorder = const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF52CA3E),
          ),
        );
      });
    }

  }

  _valid() {
    String? text = StringValidator().validateNickname(_textNicknameController.text, _nicknameMaxLength);
    if (text != null) {
      _setError(text);
      return false;
    }
    return true;
  }

  _setError(String? text) {
    if (text == null) {
      setState(() {
        _nickname = null;
        _nicknameStyle = null;
        _nicknameBorder = null;
      });
      return;
    }
    setState(() {
      _nickname = text;
      _nicknameStyle = TextStyle(
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      );
      _nicknameBorder = OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
        ),
      );
    });
  }
  UserProfile? _getProfile() {
    UserProfile? profile = ref.read(loginProvider.notifier).get();
    if (profile == null) {
      Alert.of(context).message(
        message: '회원 정보가 없습니다.',
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
    return profile;
  }

  @override
  void initState() {
    _textNicknameController = TextEditingController();
    _focusNode = FocusNode();
    editImage = ref.read(loginProvider.notifier).getImage();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _setError(null);
      }
    },);
    super.initState();
  }

  @override
  void dispose() {
    _textNicknameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    UserProfile profile = _getProfile()!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('프로필 수정',),
        actions: [
          GestureDetector(
            onTap: editProfile,
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: Text('완료',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: EdgeInsets.only(bottom: keyboardHeight),
            decoration: const BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      selectImage();
                    },
                    child: Stack(
                        children: [
                          UserProfileWidget(
                            diameter: 100.sp,
                            image: editImage,
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: const Icon(Icons.camera_alt,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
                const SpaceHeight(30,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('닉네임',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.secondary
                    ),
                  ),
                ),
                const SpaceHeight(4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: TextField(
                          controller: _textNicknameController,
                          focusNode: _focusNode,
                          style: TextStyle(
                            fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                          ),
                          maxLength: _nicknameMaxLength,
                          decoration: InputDecoration(
                            counterText: '',
                            fillColor: Colors.white,
                            filled: true,
                            errorText: _nickname,
                            errorStyle: _nicknameStyle,
                            errorBorder: _nicknameBorder,
                            enabledBorder: _inputBorder,
                            focusedErrorBorder: _inputBorder,
                            focusedBorder: _inputBorder,
                            hintText: profile.nickname,
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w400,
                              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                            ),
                          ),

                        ),
                      ),
                    ),
                    const SizedBox(width: 8,),
                    GestureDetector(
                      onTap: _distinctCheck,
                      child: Container(
                        width: 100.sp,
                        height: 55.sp,
                        decoration: _inputDecoration(),
                        child: Center(
                          child: Text('중복확인',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ),
                      ),
                    )

                  ],
                ),
                const SpaceHeight(30,),
                SizedBox(
                  height: 55.sp,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            decoration: _inputDecoration(),
                            child: Text(DateFormat('yyyy-MM-dd').format(profile.birth),
                              style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                color: Theme.of(context).colorScheme.primary
                              ),
                            )
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: double.infinity,
                          padding: const EdgeInsets.all(2),
                          decoration: _inputDecoration(),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: profile.sex == SexType.MALE
                                          ? Theme.of(context).colorScheme.onPrimary
                                          : null
                                  ),
                                  child: Center(
                                    child: Text('남자',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: profile.sex == SexType.MALE ? FontWeight.w600 : FontWeight.w400,
                                          color: profile.sex == SexType.MALE
                                              ? Colors.white
                                              : null
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: profile.sex == SexType.FEMALE
                                          ? Theme.of(context).colorScheme.onPrimary
                                          : null
                                  ),
                                  child: Center(
                                    child: Text('여자',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: profile.sex == SexType.FEMALE ? FontWeight.w600 : FontWeight.w400,
                                          color: profile.sex == SexType.FEMALE
                                              ? Colors.white
                                              : Theme.of(context).colorScheme.secondary
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  final OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
  );

  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
          color: const Color(0xFFD9D9D9)
      ),
    );
  }
}

