package Services;

import Repositories.BuyRepository;
import models.Buy;
import models.User;

public class BuyService {

    private final BuyRepository buyRepo = new BuyRepository();

    public boolean buySong(Buy buy) {
        if (checkBuyExists(buy)) {
            System.out.println("You have already bought this song.");
            return false;
        }

        boolean success = buyRepo.buySong(buy);

        if (success) {
            System.out.println("Purchase successful for song: " + buy.getSong().getTitle());
        } else {
            System.out.println("Purchase failed. Insufficient credit or error.");
        }

        return success;
    }

    public boolean checkBuyExists(Buy buy) {
        return BuyRepository.checkBuyExists(buy);
    }

    public Buy[] getAllBuys() {
        return buyRepo.buysList();
    }

    public Buy[] getBuysByUser(User user) {
        return buyRepo.getBuysListByUser(user);
    }
}
