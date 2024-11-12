
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/domain/region/find_region.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegionSelectWidget extends ConsumerStatefulWidget {

  final bool excludeAll;
  final Function(Region) onPressed;

  const RegionSelectWidget({super.key, this.excludeAll = false, required this.onPressed});

  @override
  ConsumerState<RegionSelectWidget> createState() => _RegionSettingsWidgetState();
}

class _RegionSettingsWidgetState extends ConsumerState<RegionSelectWidget> {

  List<Region> _find = [];

  changeEvent(String word) {
    setState(() {
      _find = [Region.ALL, ...FindRegion.search(word)];
    });
  }

  initRegion() {
    Region? myRegion = ref.read(regionProvider.notifier).get();
    setState(() {
      if (myRegion == null) {
        _find = [Region.ALL];
      } else {
      _find = {Region.ALL, myRegion}.toList();
      }
    });
  }

  @override
  void initState() {
    initRegion();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFF1F3F5),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: changeEvent,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '지역을 입력해주세요.',
                    hintStyle: TextStyle(
                      color: Color(0xFF908E9B),
                    ),
                  ),
                  autofocus: true,
                ),
              ),
              const SizedBox(width: 10,),
              SvgIcon.asset(sIcon: SIcon.search),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // TextField 외에 다른 부분 터치 시 unfocus
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              height: 0.2,
              decoration: const BoxDecoration(
                color: Color(0xFF959595),
              ),
            ),
            itemCount: _find.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: _FindResultRegionWidget(locale: const Locale('ko', 'KR'), region: _find[index], setRegion: widget.onPressed,),
              );
            },
          ),
        ),
      )
    );
  }
}

class _FindResultRegionWidget extends ConsumerStatefulWidget {

  final Function(Region) setRegion;
  final Region region;
  final Locale locale;

  const _FindResultRegionWidget({required this.region, required this.locale, required this.setRegion});

  @override
  ConsumerState<_FindResultRegionWidget> createState() => _FindResultRegionWidgetState();
}

class _FindResultRegionWidgetState extends ConsumerState<_FindResultRegionWidget> {
  @override
  Widget build(BuildContext context) {
    String name = widget.region.getLocaleName(widget.locale);
    return GestureDetector(
      onTap: () {
        widget.setRegion(widget.region);
        Navigator.pop(context);
      },
      child: Container(
        decoration: const BoxDecoration(),
        child: Text(name,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary
          ),
        ),
      ),
    );
  }
}