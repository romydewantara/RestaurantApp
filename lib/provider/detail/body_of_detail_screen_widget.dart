import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app/provider/detail/read_more_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/screen/detail/category_card_widget.dart';
import 'package:restaurant_app/screen/detail/favorite_icon_widget.dart';
import 'package:restaurant_app/screen/detail/menu_card_widget.dart';
import 'package:restaurant_app/screen/detail/review_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/utils/sliver_header_delegate.dart';

class BodyOfDetailScreenWidget extends StatefulWidget {
  final RestaurantDetail restaurantDetail;

  const BodyOfDetailScreenWidget({super.key, required this.restaurantDetail});

  @override
  State<BodyOfDetailScreenWidget> createState() =>
      _BodyOfDetailScreenWidgetState();
}

class _BodyOfDetailScreenWidgetState extends State<BodyOfDetailScreenWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = context.watch<ReadMoreProvider>().isExpanded;

    return CustomScrollView(
      key: ValueKey("detailScreen"),
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          expandedHeight: 200.0,
          pinned: false,
          floating: true,
          snap: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: widget.restaurantDetail.pictureId,
              child: Image.network(
                'https://restaurant-api.dicoding.dev/images/small/${widget.restaurantDetail.pictureId}',
                fit: BoxFit.cover,
              ),
            ),
            expandedTitleScale: 1.5,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.restaurantDetail.name,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(40, 40),
                          blurRadius: 70,
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      maxWidth: 30,
                      minHeight: 30,
                      maxHeight: 30,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: ChangeNotifierProvider(
                        create: (context) => FavoriteIconProvider(),
                        child: Consumer<RestaurantListProvider>(
                          builder: (context, value, child) {
                            final id = widget.restaurantDetail.id;
                            final restaurant = context
                                .watch<RestaurantListProvider>()
                                .getRestaurantById(id);

                            return FavoriteIconWidget(restaurant: restaurant!);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            titlePadding: const EdgeInsets.all(6),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox.square(
              dimension: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          child: Row(
                        children: [
                          const Icon(
                            Icons.pin_drop,
                            color: Colors.redAccent,
                          ),
                          const SizedBox.square(
                            dimension: 4,
                          ),
                          SizedBox(
                            child: Text(
                              widget.restaurantDetail.address,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        ],
                      )),
                      SizedBox(
                          child: Row(
                        children: [
                          const Icon(
                            Icons.location_city,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox.square(
                            dimension: 4,
                          ),
                          SizedBox(
                            child: Text(
                              widget.restaurantDetail.city,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.blueGrey,
                          blurRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: (widget.restaurantDetail.rating < 4)
                                ? Colors.red
                                : Colors.green,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                            child: Row(
                              children: [
                                Text(widget.restaurantDetail.rating.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox.square(
                                  dimension: 4,
                                ),
                                const Icon(Icons.star, color: Colors.yellow),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 6.0, top: 2.0),
                          child: Text(
                            'Ratings',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox.square(
              dimension: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.reviewRoute.name,
                        arguments: widget.restaurantDetail.id,
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Write a review',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox.square(dimension: 4),
                        Icon(
                          Icons.note_alt_outlined,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox.square(dimension: 2),
            SizedBox(
              height: 125,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.restaurantDetail.customerReview.length,
                itemBuilder: (context, index) {
                  return ReviewCardWidget(
                    review: widget.restaurantDetail.customerReview[index],
                  );
                },
              ),
            ),
            const SizedBox.square(
              dimension: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Description',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox.square(dimension: 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    widget.restaurantDetail.description,
                    maxLines: isExpanded ? null : 4,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<ReadMoreProvider>().toggleExpanded();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          isExpanded ? "Read Less" : "Read More…",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox.square(dimension: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 55,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.restaurantDetail.categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCardWidget(
                        category: widget.restaurantDetail.categories[index]);
                  },
                ),
              ),
            ),
            const SizedBox.square(
              dimension: 16,
            )
          ]),
        ),
        _header(context, "Foods"),
        SliverList.builder(
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 100.0,
              height: 100.0,
              child: Center(
                child: MenuCardWidget(
                  title:
                      widget.restaurantDetail.menu.foods[index].name.toString(),
                ),
              ),
            );
          },
          itemCount: widget.restaurantDetail.menu.foods.length,
        ),
        _header(context, "Drinks"),
        SliverList.builder(
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 100.0,
              height: 100.0,
              child: Center(
                child: MenuCardWidget(
                  title: widget.restaurantDetail.menu.drinks[index].name
                      .toString(),
                ),
              ),
            );
          },
          itemCount: widget.restaurantDetail.menu.drinks.length,
        ),
      ],
    );
  }

  SliverPersistentHeader _header(
    BuildContext context,
    String text,
  ) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverHeaderDelegate(
        minHeight: 55,
        maxHeight: 55,
        child: Container(
          color: Color(0xFF0c4160),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
