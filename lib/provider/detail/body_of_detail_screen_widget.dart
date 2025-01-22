import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/screen/detail/category_card_widget.dart';
import 'package:restaurant_app/screen/detail/menu_card_widget.dart';
import 'package:restaurant_app/screen/detail/review_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/utils/sliver_header_delegate.dart';

class BodyOfDetailScreenWidget extends StatelessWidget {
  final RestaurantDetail restaurantDetail;

  const BodyOfDetailScreenWidget({super.key, required this.restaurantDetail});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
              tag: restaurantDetail.pictureId,
              child: Image.network(
                'https://restaurant-api.dicoding.dev/images/small/${restaurantDetail.pictureId}',
                fit: BoxFit.cover,
              ),
            ),
            expandedTitleScale: 1.5,
            title: Text(
              restaurantDetail.name,
              style: TextStyle(
                fontSize: 24,
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
                            restaurantDetail.address,
                            style: Theme.of(context).textTheme.titleMedium,
                          ))
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
                            restaurantDetail.city,
                            style: Theme.of(context).textTheme.titleMedium,
                          ))
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
                          )
                        ]),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: (restaurantDetail.rating < 4)
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
                                Text(restaurantDetail.rating.toString(),
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
                        arguments: restaurantDetail.id,
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
                itemCount: restaurantDetail.customerReview.length,
                itemBuilder: (context, index) {
                  return ReviewCardWidget(
                      review: restaurantDetail.customerReview[index]);
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                restaurantDetail.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox.square(dimension: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 55,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: restaurantDetail.categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCardWidget(
                        category: restaurantDetail.categories[index]);
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
                          restaurantDetail.menus.foods[index].name.toString())),
            );
          },
          itemCount: restaurantDetail.menus.foods.length,
        ),
        _header(context, "Drinks"),
        SliverList.builder(
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 100.0,
              height: 100.0,
              child: Center(
                  child: MenuCardWidget(
                      title: restaurantDetail.menus.drinks[index].name
                          .toString())),
            );
          },
          itemCount: restaurantDetail.menus.drinks.length,
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
                child: Text(text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ),
            )));
  }
}
