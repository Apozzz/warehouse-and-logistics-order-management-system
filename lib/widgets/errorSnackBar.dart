import 'package:inventory_system/imports.dart';

class ErrorSnackBar {
  SnackBar getErrorSnackBar(BuildContext context, String errorMessage) {
    return SnackBar(
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      showCloseIcon: true,
      content: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: 110,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 38,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Oops Error!',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        errorMessage,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 25,
            left: 20,
            child: ClipRRect(
              child: Stack(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.red.shade200,
                    size: 17,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: -20,
            left: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                const Positioned(
                  top: 5,
                  child: Icon(
                    Icons.clear_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
