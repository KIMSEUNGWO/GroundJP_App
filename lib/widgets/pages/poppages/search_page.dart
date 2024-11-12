
import 'dart:math';

import 'package:groundjp/api/service/field_service.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/local_storage.dart';
import 'package:groundjp/component/recently_search_word.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/domain/field/field_simp.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/component/favorite_field_list.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundjp/widgets/form/settings_menu_form.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  final TextEditingController _textController = TextEditingController();
  List<FieldSimp> _fields = [];
  bool _loading = false;

  final RecentlySearchWord _recentlySearchWord = RecentlySearchWord();

  bool recentlySearchIsDisable = false;

  addWord(String word) {
    _recentlySearchWord.addWord(word);
    setState(() {});
  }
  deleteWord(String word) {
    _recentlySearchWord.deleteWord(word);
    setState(() {});
  }
  deleteAllWord() {
    _recentlySearchWord.deleteAllWord();
    setState(() {
      recentlySearchIsDisable = true;
    });
  }

  textClear() {
    _textController.clear();
    setState(() {
      recentlySearchIsDisable = false;
    });
  }

  onTapRecentlyWord(String word) {
    _textController.text = word;
    onChange(word);
    onSubmit(word);
  }

  onSubmit(String word) {
    if (word.isEmpty || word.length < 2) {
      Alert.of(context).message(
        message: '2자 이상 입력해주세요.',
      );
      return;
    }
    addWord(word); // 최근

    print('onSubmit $word' );// 검색어 추가
    _fetch(word);
  }
  _fetch(String word) async {
    if (_loading) return;
    setState(() {
      _loading = true;
    });
    List<FieldSimp> result = await FieldService.instance.searchFields(word);
    setState(() {
      _fields = result;
      _loading = false;
    });
  }

  onChange(String word) {
    setState(() => recentlySearchIsDisable = word.isNotEmpty);
  }

  _init() async {
    await _recentlySearchWord.init();
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    LocalStorage.instance.saveByRecentlySearchWord(_recentlySearchWord.toList());
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  onSubmitted: (value) => onSubmit(value),
                  onChanged: (value) => onChange(value),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '구장을 입력해주세요.',
                    hintStyle: TextStyle(
                      color: Color(0xFF908E9B),
                    ),
                  ),
                  autofocus: true,
                ),
              ),
              const SizedBox(width: 10,),
              if (_textController.text.isNotEmpty)
                GestureDetector(
                  onTap: () => textClear(),
                  child: const Icon(Icons.cancel,
                    color: Color(0xFF797979),
                    size: 22,
                  ),
                ),
              const SizedBox(width: 10,),
              SvgIcon.asset(sIcon: SIcon.search),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32)
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            // 키보드 만큼의 padding을 줘야함
            padding: EdgeInsets.only(
              left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                const SpaceHeight(30),
                if (!recentlySearchIsDisable && _recentlySearchWord.isNotEmpty())
                  RecentlySearchWordWidget(
                    words : _recentlySearchWord.toList(),
                    addWord : addWord,
                    deleteWord : deleteWord,
                    deleteAllWord : deleteAllWord,
                    onTap : onTapRecentlyWord,
                  ),
                _loading ? const Center(child: CupertinoActivityIndicator(),) :
                Column(
                  children: ListSeparatorBuilder(
                    items: _fields.map((fieldSimp) => FavoriteFieldListWidget(fieldSimp: fieldSimp)).toList(),
                    separator: const SpaceHeight(16),
                  ).build(),
                ),
                const SpaceHeight(30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecentlySearchWordWidget extends StatefulWidget {

  final List<String> words;
  final Function(String word) addWord;
  final Function(String word) deleteWord;
  final Function() deleteAllWord;
  final Function(String word) onTap;

  const RecentlySearchWordWidget({super.key, required this.words, required this.addWord, required this.deleteWord, required this.deleteAllWord, required this.onTap});



  @override
  State<RecentlySearchWordWidget> createState() => _RecentlySearchWordWidgetState();
}

class _RecentlySearchWordWidgetState extends State<RecentlySearchWordWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('최근 검색어',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.deleteAllWord(),
                  child: Text('전체삭제',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                      color: Theme.of(context).colorScheme.secondary
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          CustomContainer(
            child: GridView.builder(
              shrinkWrap: true, // chid 위젯의 크기를 정해주지 않아싿면 true로 지정해줘야한다.
              physics: const NeverScrollableScrollPhysics(), // 스크롤 금지
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisExtent: 30,
                  mainAxisSpacing: 10
              ),
              itemCount: min(widget.words.length, 6),

              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onTap(widget.words[index]),
                        child: Text(widget.words[index],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    GestureDetector(
                      onTap: () {
                        widget.deleteWord(widget.words[index]);
                      },
                      child: const Icon(Icons.close, size: 13,),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
