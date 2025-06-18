<?php

namespace App\Command;

use App\Entity\Post;
use Doctrine\ORM\EntityManagerInterface;
use Faker\Factory;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(name: 'tool:generate-dummy-post')]
readonly class GenerateDummyPostCommand
{
    public function __construct(private EntityManagerInterface $em)
    {
    }

    public function __invoke(SymfonyStyle $io): int
    {
        $io->title('📝 Generating dummy posts...');
        $io->writeln('======================================================================');
        $io->writeln('⏳ Setting memory limit to unlimited...');
        ini_set('memory_limit', '-1');

        $faker = Factory::create();
        $total = 200_000;
        $batchSize = 1000;

        $io->success("Starting generation of $total posts");
        $io->progressStart($total);

        for ($i = 1; $i <= $total; $i++) {
            $post = new Post();
            $post->setTitle($faker->sentence(6, true));
            $post->setDescription($faker->paragraphs(10, true));
            $post->setCreatedAt(\DateTimeImmutable::createFromMutable($faker->dateTimeBetween('-1 years', 'now')));
            $this->em->persist($post);

            if ($i % $batchSize === 0) {
                $this->em->flush();
                $this->em->clear();
                gc_collect_cycles();
            }

            $io->progressAdvance();
        }

        $this->em->flush();
        $this->em->clear();

        $io->progressFinish();
        $io->success("Successfully generated $total posts!");

        return Command::SUCCESS;
    }
}
