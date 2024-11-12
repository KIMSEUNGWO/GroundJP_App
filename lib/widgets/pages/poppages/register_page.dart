
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/select_date_dialog.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/user/social_result.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterWidget extends ConsumerStatefulWidget {

  final SocialResult social;

  const RegisterWidget({super.key, required this.social});

  @override
  ConsumerState<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends ConsumerState<RegisterWidget> {

  DateTime? _birth;
  SexType? _sexType;
  bool _disabled = true;

  void _trySubmit() {
    if (_disabled) return;
    setState(() {
      _disabled = true;
    });
    Alert.of(context).confirm(
      message: '가입 이후에는 해당 정보를 수정할 수 없습니다. \n가입 하시겠습니까?',
      btnMessage: '가입',
      onPressed: () {
        _submit();
      },
      onCanceled: () {
        setState(() {
          _disabled = false;
        });
      }
    );
  }
  void _submit() async {
    bool result = await ref.watch(loginProvider.notifier).register(ref, sex: _sexType!, birth: _birth!, social: widget.social);
    if (result) {
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _disabled = false;
      });
    }
  }
  _canSubmit() {
    bool canSubmit = _birth != null && _sexType != null;
    setState(() {
      _disabled = !canSubmit;
    });
  }

  void _selectBirth() {
    SelectDateDialog.of(context)
        .selectDate(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: _birth,
        onPressed: (p0) {
          setState(() {
              _birth = p0;
            });
        },
    );
    _canSubmit();
  }
  void _selectSex(SexType sexType) {
    setState(() {
      _sexType = sexType;
    });
    _canSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 21),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('회원가입',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 12,),
              Text('생년월일과 성별을 입력해주세요.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                ),
              ),
              const SizedBox(height: 36,),
              SizedBox(
                height: 55,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: _selectBirth,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: _inputDecoration(),
                          child: _birth == null
                            ? Text('생년월일', style: TextStyle(fontSize: 16))
                            : Text(DateFormat('yyyy-MM-dd').format(_birth!),
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary
                            ),
                          )
                        ),
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
                              child: GestureDetector(
                                onTap: () => _selectSex(SexType.MALE),
                                child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: _sexType == SexType.MALE
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : null
                                  ),
                                  child: Center(
                                    child: Text('남자',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: _sexType == SexType.MALE ? FontWeight.w600 : FontWeight.w400,
                                        color: _sexType == SexType.MALE
                                          ? Colors.white
                                          : null
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () => _selectSex(SexType.FEMALE),
                                child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: _sexType == SexType.FEMALE
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : null
                                  ),
                                  child: Center(
                                    child: Text('여자',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: _sexType == SexType.FEMALE ? FontWeight.w600 : FontWeight.w400,
                                        color: _sexType == SexType.FEMALE
                                          ? Colors.white
                                          : Theme.of(context).colorScheme.secondary
                                      ),
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
      bottomNavigationBar: SafeArea(
        child: GestureDetector(
          onTap: _trySubmit,
          child: Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: _disabled
                ? const Color(0xFFD9D9D9)
                : Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('완료',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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


