
import 'package:groundjp/component/pageable.dart';
import 'package:flutter/cupertino.dart';

class PageableListView<T> extends StatefulWidget {

  final int pageableSize;
  final IndexedWidgetBuilder separatorBuilder;
  final PageFutureCallback<T> future;
  final PageableViewWidget<T> builder;
  final bool isSliver;

  const PageableListView({super.key, required this.pageableSize, required this.separatorBuilder, required this.future, required this.builder, this.isSliver = false});
  const PageableListView.sliver({super.key, required this.pageableSize, required this.separatorBuilder, required this.future, required this.builder, this.isSliver = true});

  @override
  State<PageableListView<T>> createState() => PageableListViewState<T>();

}

class PageableListViewState<T> extends State<PageableListView<T>> {

  final List<T> _items = [];
  late Pageable _pageable;
  bool _loading = true;

  removeItem(bool Function(T) onRemove) {
    for (var o in _items) {
      if (onRemove(o)) {
        _items.remove(o);
        break;
      }
    }
    setState(() {});
  }

  _fetch() async {
    List<T> moreData = await widget.future(_pageable.nextPage());
    setState(() {
      _pageable.hasMore = _pageable.size <= moreData.length;
      _items.addAll(moreData);
      _loading = false;
    });
  }
  _initData() async {
    List<T> data = await widget.future(_pageable);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      setState(() {
        _pageable.hasMore = _pageable.size <= data.length;
        _items.addAll(data);
        _loading = false;
      });
    },);
  }

  _initPageable() {
    _pageable = Pageable(
      size: widget.pageableSize,
    );
  }

  @override
  void initState() {
    _initPageable();
    _initData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return widget.isSliver ? const LoadingIndicator.sliver() : const LoadingIndicator();
    return widget.isSliver ? buildListView().buildChildLayout(context) : buildListView();
  }

  ListView buildListView() {
    return ListView.separated(
    separatorBuilder: widget.separatorBuilder,
    itemCount: _items.length + (_pageable.hasMore ? 1 : 0),
    itemBuilder: (context, index) {
      if (_items.isNotEmpty && index == _items.length && !_loading && _pageable.hasMore) {
        _fetch();
        return const LoadingIndicator();
      }
      return widget.builder(_items[index]);
    },
  );
  }
}

class LoadingIndicator extends StatelessWidget {

  final Widget _indicator;

  const LoadingIndicator({super.key}): _indicator = const Center(child: CupertinoActivityIndicator(),);
  const LoadingIndicator.sliver({super.key}): _indicator = const SliverToBoxAdapter(child: Center(child: CupertinoActivityIndicator(),),);

  @override
  Widget build(BuildContext context) {
    return _indicator;
  }
}



