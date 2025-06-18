<?php

namespace App\DataFixtures;

use App\Entity\Post;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Faker\Factory;

class AppFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        $faker = Factory::create();

        $batchSize = 1000;
        $totalPosts = 200000;

        for ($i = 1; $i <= $totalPosts; $i++) {
            $post = new Post();
            $post->setTitle($faker->sentence(6, true));
            $post->setDescription($faker->paragraphs(10, true));
            $post->setCreatedAt(\DateTimeImmutable::createFromMutable($faker->dateTimeBetween('-1 years', 'now')));

            $manager->persist($post);

            if ($i % $batchSize === 0) {
                $manager->flush();
                $manager->clear();
                gc_collect_cycles();
                echo "Inserted $i records...\n";
            }
        }

        $manager->flush();
        $manager->clear();
    }
}
