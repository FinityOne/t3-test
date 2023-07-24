import { object, z } from "zod";
import {
  createTRPCRouter,
  publicProcedure,
  protectedProcedure,
} from "~/server/api/trpc";
import { generatePaymentUrl } from "../services/stripe_service";

export const exampleRouter = createTRPCRouter({
  getEvents: publicProcedure.query(async ({ input, ctx }) => {
    return await ctx.prisma.event.findMany();
  }),
  getEvent: publicProcedure
    .input(z.object({ id: z.string() }))
    .query(async ({ input, ctx }) => {
      return await ctx.prisma.event.findUnique({
        where: { id: input.id },
      });
    }),
  createEvent: publicProcedure
    .input(
      z.object({
        name: z.string(),
      })
    )
    .mutation(async ({ input, ctx }) => {
      return await ctx.prisma.event.create({
        data: {
          title: input.name,
          event_date: new Date(),
          is_active: false,
        },
      });
    }),

  getStripePaymentUrl: publicProcedure.mutation(
    async ({ input, ctx }) => {
      // call getStripePaymentUrl
      return generatePaymentUrl("test", 1000);
    }
  ),
  getSecretMessage: protectedProcedure.query(() => {
    return "you can now see this secret message!";
  }),
});
