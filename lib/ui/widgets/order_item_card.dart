part of 'widgets.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem orderitem;
  OrderItemCard(this.orderitem);

  @override
  _OrderItemCardState createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isExpanded
          ? min(widget.orderitem.product.length * 20.0 + 110, 220)
          : 80,
      child: Card(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text("\$${widget.orderitem.amount}"),
                subtitle: Text(DateFormat("dd MM yyyy hh:mm")
                    .format(widget.orderitem.dateTime)),
                trailing: IconButton(
                    icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    }),
              ),
              if (isExpanded) Divider(),
              AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                  height: isExpanded
                      ? min(widget.orderitem.product.length * 20.0 + 10, 100)
                      : 0,
                  child: ListView(
                      children: widget.orderitem.product
                          .map((e) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.title),
                                  Text(
                                      "${e.quantity.toString()}x \$${e.price.toString()}")
                                ],
                              ))
                          .toList()))
            ],
          ),
        ),
      ),
    );
  }
}
