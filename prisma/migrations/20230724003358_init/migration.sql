-- CreateTable
CREATE TABLE `member` (
    `id` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `first_name` VARCHAR(191) NULL,
    `last_name` VARCHAR(191) NULL,
    `phone_number` VARCHAR(191) NULL,
    `member_tier` ENUM('BRONZE', 'GOLD', 'DIAMOND') NOT NULL DEFAULT 'BRONZE',
    `street_address` VARCHAR(191) NULL,
    `city` VARCHAR(191) NULL,
    `state` VARCHAR(191) NULL,
    `zip` VARCHAR(191) NULL,
    `won_referral` BOOLEAN NULL DEFAULT false,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `member_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `payment_methods` (
    `id` VARCHAR(191) NOT NULL,
    `member_id` VARCHAR(191) NOT NULL,
    `cc_number` INTEGER NOT NULL,
    `cc_expiration` INTEGER NOT NULL,
    `cc_cvv` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `event` (
    `id` VARCHAR(191) NOT NULL,
    `event_type` ENUM('SINGLE', 'COMBO') NOT NULL DEFAULT 'SINGLE',
    `title` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `event_date` DATETIME(3) NOT NULL,
    `start_datetime` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `end_datetime` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `location` VARCHAR(191) NULL,
    `street_address` VARCHAR(191) NULL,
    `city` VARCHAR(191) NULL,
    `state` VARCHAR(191) NULL,
    `zip` INTEGER NULL,
    `photo_url` VARCHAR(191) NULL,
    `is_active` BOOLEAN NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ticket` (
    `id` VARCHAR(191) NOT NULL,
    `event_id` VARCHAR(191) NOT NULL,
    `ticket_type` ENUM('SINGLE', 'COMBO') NOT NULL,
    `ticket_tier` ENUM('GA', 'GOLD', 'DIAMOND') NOT NULL,
    `ticket_urgency` ENUM('EARLYBIRD', 'REGULAR', 'DOOR') NOT NULL DEFAULT 'EARLYBIRD',
    `stripe_id` VARCHAR(191) NULL,
    `sales_start_date` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
    `sales_end_date` DATETIME(3) NULL,
    `name` VARCHAR(191) NULL,
    `description` VARCHAR(191) NULL,
    `photo_url` VARCHAR(191) NULL,
    `price` DOUBLE NOT NULL,
    `qty_left` INTEGER NOT NULL,
    `qty_sold` INTEGER NOT NULL,
    `group_disc_min` INTEGER NOT NULL,
    `group_price` DOUBLE NOT NULL,
    `platform_fee` DOUBLE NOT NULL,
    `original_ticket` ENUM('EARLYBIRD', 'REGULAR', 'DOOR') NOT NULL DEFAULT 'REGULAR',
    `original_price` DOUBLE NULL,
    `is_active` BOOLEAN NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `promocode` (
    `id` VARCHAR(191) NOT NULL,
    `code_name` VARCHAR(191) NOT NULL,
    `discount_amount` DOUBLE NOT NULL,
    `qty_used` INTEGER NOT NULL DEFAULT 0,
    `is_active` BOOLEAN NOT NULL DEFAULT true,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `order` (
    `id` VARCHAR(191) NOT NULL,
    `order_number` VARCHAR(191) NOT NULL,
    `member_id` VARCHAR(191) NOT NULL,
    `billing_street_address` VARCHAR(191) NOT NULL,
    `billing_city` VARCHAR(191) NOT NULL,
    `billing_state` VARCHAR(191) NOT NULL,
    `billing_zip` INTEGER NOT NULL,
    `num_of_items` INTEGER NOT NULL,
    `subtotal` DOUBLE NOT NULL,
    `platform_fees` DOUBLE NOT NULL,
    `promo_code_applied` BOOLEAN NULL,
    `promocode_id` VARCHAR(191) NULL,
    `discount_given` DOUBLE NULL,
    `order_total` DOUBLE NOT NULL,
    `is_paid` BOOLEAN NOT NULL,
    `email_sent` BOOLEAN NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `order_item` (
    `id` VARCHAR(191) NOT NULL,
    `order_id` VARCHAR(191) NOT NULL,
    `ticket_id` VARCHAR(191) NOT NULL,
    `qty_ordered` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `referral` (
    `id` VARCHAR(191) NOT NULL,
    `referring_member_id` VARCHAR(191) NOT NULL,
    `referral_email` VARCHAR(191) NULL,
    `referral_phone` VARCHAR(191) NULL,
    `referral_date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `payment_methods` ADD CONSTRAINT `payment_methods_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `member`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ticket` ADD CONSTRAINT `ticket_event_id_fkey` FOREIGN KEY (`event_id`) REFERENCES `event`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `order` ADD CONSTRAINT `order_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `member`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `order` ADD CONSTRAINT `order_promocode_id_fkey` FOREIGN KEY (`promocode_id`) REFERENCES `promocode`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `order_item` ADD CONSTRAINT `order_item_order_id_fkey` FOREIGN KEY (`order_id`) REFERENCES `order`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `order_item` ADD CONSTRAINT `order_item_ticket_id_fkey` FOREIGN KEY (`ticket_id`) REFERENCES `ticket`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `referral` ADD CONSTRAINT `referral_referring_member_id_fkey` FOREIGN KEY (`referring_member_id`) REFERENCES `member`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
