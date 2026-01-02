import 'package:flutter/material.dart';

class CardList extends StatefulWidget {
  final String title;
  final double price;
  final String imgUrl;
  final bool isFav;
  final int sold;
  final int liked;
  final int limitPurchase;
  final double originalPrice;
  final Function() onTabCard;

  const CardList({
    super.key,
    required this.title,
    required this.price,
    required this.imgUrl,
    required this.isFav,
    required this.sold,
    required this.liked,
    required this.limitPurchase,
    required this.onTabCard,
    required this.originalPrice,
  });

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  late bool fav;

  @override
  void initState() {
    super.initState();
    fav = widget.isFav;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(22, 0, 0, 0),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 140,
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(widget.imgUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 18,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        fav = !fav;
                      });
                    },
                    child: Icon(
                      fav ? Icons.favorite : Icons.favorite_border,
                      color: fav ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8, right: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.sold}+ sold • ${widget.liked} liked",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: widget.onTabCard,
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "• Limit purchase ${widget.liked}",
                      style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                    ),
                    Row(
                      children: [
                        Text(
                          "\$${widget.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 6),
                        if (widget.originalPrice > widget.price)
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "\$${widget.originalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
