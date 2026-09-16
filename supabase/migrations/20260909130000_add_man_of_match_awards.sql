-- Man of the Match (per match) and Man of the Tournament (per tournament),
-- both auto-computed - see ScoreBoardViewNotifier._computeManOfTheMatch and
-- TournamentService.updateTournamentStats.

alter table public.matches
  add column man_of_the_match_id uuid references public.users (id) on delete set null;

alter table public.tournaments
  add column man_of_the_tournament_id uuid references public.users (id) on delete set null;
