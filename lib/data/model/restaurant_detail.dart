class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menu menu;
  final num rating;
  final List<Review> customerReview;

  const RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menu,
    required this.rating,
    required this.customerReview,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        city: json["city"],
        address: json["address"],
        pictureId: json["pictureId"],
        categories: List<Category>.from(
          json["categories"].map((x) => Category.fromJson(x)),
        ),
        menu: Menu.fromJson(json["menus"]),
        rating: json["rating"]?.toDouble(),
        customerReview: List<Review>.from(
          json["customerReviews"].map((x) => Review.fromJson(x)),
        ),
      );
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json["name"]);
}

class Menu {
  List<Category> foods;
  List<Category> drinks;

  Menu({required this.foods, required this.drinks});

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    foods: List<Category>.from(json["foods"].map((x) => Category.fromJson(x))),
    drinks: List<Category>.from(
      json["drinks"].map((x) => Category.fromJson(x)),
    ),
  );
}

class Food {
  final List<Name> name;

  const Food({required this.name});

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    name: json["foods"] != null
        ? List<Name>.from(json["drinks"]!.map((x) => Name.fromJson(x)))
        : <Name>[],
  );
}

class Drink {
  final List<Name> name;

  const Drink({required this.name});

  factory Drink.fromJson(Map<String, dynamic> json) => Drink(
    name: json["drinks"] != null
        ? List<Name>.from(json["drinks"]!.map((x) => Name.fromJson(x)))
        : <Name>[],
  );
}

class Review {
  final String name;
  final String review;
  final String date;

  const Review({required this.name, required this.review, required this.date});

  factory Review.fromJson(Map<String, dynamic> json) =>
      Review(name: json["name"], review: json["review"], date: json["date"]);
}

class Name {
  final String name;

  const Name({required this.name});

  factory Name.fromJson(Map<String, dynamic> json) => Name(name: json["name"]);
}
