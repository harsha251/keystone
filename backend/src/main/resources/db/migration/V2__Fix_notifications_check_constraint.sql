-- Fix notifications check constraint to include all NotificationType values
-- Safe for both fresh and existing databases.

DO $$
BEGIN
    IF to_regclass('public.notifications') IS NOT NULL THEN

        IF EXISTS (
            SELECT 1
            FROM pg_constraint
            WHERE conname = 'notifications_type_check'
              AND conrelid = 'public.notifications'::regclass
        ) THEN
            ALTER TABLE public.notifications
            DROP CONSTRAINT notifications_type_check;
        END IF;

        ALTER TABLE public.notifications
        ADD CONSTRAINT notifications_type_check
        CHECK (
            type IN (
                'WORK_ORDER_ASSIGNED',
                'WORK_ORDER_STATUS_CHANGED',
                'SLA_AT_RISK',
                'SLA_BREACHED'
            )
        );

    END IF;
END $$;
