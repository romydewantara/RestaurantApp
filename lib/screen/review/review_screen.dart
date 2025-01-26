import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/provider/review/restaurant_review_provider.dart';
import 'package:restaurant_app/screen/detail/review_card_widget.dart';
import 'package:restaurant_app/static/restaurant_review_result_state.dart';

class ReviewScreen extends StatefulWidget {
  final String restaurantId;

  const ReviewScreen({super.key, required this.restaurantId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<RestaurantReviewProvider>(
                builder: (context, value, child) {
                  return switch (value.resultState) {
                    RestaurantReviewLoadingState() => Center(
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Lottie.asset("assets/loading.json"),
                        ),
                      ),
                    RestaurantReviewLoadedState(data: var customerReview) =>
                      SizedBox(
                        height: 125,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: customerReview.length,
                          itemBuilder: (context, index) {
                            List<Review> reversedReview = [];
                            for (int i = customerReview.length - 1;
                                i >= 0;
                                i--) {
                              reversedReview.add(customerReview[i]);
                            }
                            return ReviewCardWidget(
                              review: reversedReview[index],
                            );
                          },
                        ),
                      ),
                    RestaurantReviewErrorState(error: var message) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    child: Image.network(
                                      'https://raw.githubusercontent.com/romydewantara/Resources/refs/heads/main/images/Restaurant/error.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox.square(dimension: 10),
                            Text(message),
                          ],
                        ),
                      ),
                    _ => const SizedBox(),
                  };
                },
              ),
              const SizedBox.square(dimension: 32),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 52,
                    minHeight: 52,
                    maxWidth: 52,
                    minWidth: 52,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.network(
                      'https://raw.githubusercontent.com/romydewantara/Resources/refs/heads/main/images/Restaurant/profile.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox.square(dimension: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write a review',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                    ),
                    Text(
                      'Please insert your name and fill the review',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ]),
              const SizedBox.square(dimension: 28),
              Consumer<ReviewProvider>(
                builder: (context, value, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        maxLength: 12,
                        maxLines: 1,
                        minLines: 1,
                        controller: value.controllerName,
                        decoration: InputDecoration(
                          labelText: 'Your name',
                          hintText: 'Example: Curious George',
                          errorText: value.errorTextName,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: Icon(Icons.perm_identity),
                        ),
                        onChanged: (value) {
                          Provider.of<ReviewProvider>(context, listen: false)
                              .updateFieldName(value);
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox.square(dimension: 16),
                      TextField(
                        maxLength: 250,
                        maxLines: 5,
                        minLines: 3,
                        controller: value.controllerReview,
                        decoration: InputDecoration(
                          labelText: 'Review',
                          errorText: value.errorTextReview,
                          hintText: "How about the restaurant…",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: Icon(Icons.note_alt),
                        ),
                        onChanged: (value) {
                          Provider.of<ReviewProvider>(context, listen: false)
                              .updateFieldReview(value);
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox.square(dimension: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (value.controllerName.text.isEmpty) {
                              Provider.of<ReviewProvider>(context,
                                      listen: false)
                                  .updateErrorTextName();
                              return;
                            }

                            if (value.controllerReview.text.isEmpty) {
                              Provider.of<ReviewProvider>(context,
                                      listen: false)
                                  .updateErrorTextReview();
                              return;
                            }

                            Future.microtask(() {
                              context
                                    .read<RestaurantReviewProvider>()
                                    .writeRestaurantReview(
                                      widget.restaurantId,
                                      value.fieldName!,
                                      value.fieldReview!,
                                    );
                              },
                            );
                            Provider.of<ReviewProvider>(context, listen: false)
                                .reset();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text('Submit'),
                        ),
                      ),
                      const SizedBox.square(dimension: 16),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewProvider extends ChangeNotifier {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerReview = TextEditingController();
  String? _errorTextName;
  String? _errorTextReview;
  String? _name;
  String? _review;

  TextEditingController get controllerName => _controllerName;
  TextEditingController get controllerReview => _controllerReview;

  String? get errorTextName => _errorTextName;
  String? get errorTextReview => _errorTextReview;
  String? get fieldName => _name;
  String? get fieldReview => _review;

  void updateFieldName(String value) {
    _name = value;
    notifyListeners();
  }

  void updateFieldReview(String value) {
    _review = value;
    notifyListeners();
  }

  void updateErrorTextName() {
    _errorTextName = 'This field cannot be empty';
    notifyListeners();
  }

  void updateErrorTextReview() {
    _errorTextReview = 'This field cannot be empty';
    notifyListeners();
  }

  void reset() {
    _errorTextName = null;
    _errorTextReview = null;
    _controllerName.clear();
    _controllerReview.clear();
    notifyListeners();
  }
}
