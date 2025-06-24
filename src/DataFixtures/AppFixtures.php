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
        $manager->getConnection()->getConfiguration()->setSQLLogger(null);
        $faker = Factory::create();

        $batchSize = 1000;
        $totalPosts = 200000;

        $evm = $manager->getEventManager();

        $doctrineEvents = [
            'postPersist',
            'postUpdate',
            'preRemove',
            'loadClassMetadata',
        ];

        foreach ($doctrineEvents as $event) {
            foreach ($evm->getListeners($event) as $listener) {
                $evm->removeEventListener($event, $listener);
            }
        }


        for ($i = 1; $i <= $totalPosts; $i++) {
            $post = new Post();
            $post->setTitle($faker->sentence(6, true));
            $post->setDescription($faker->text(200));
            $post->setCreatedAt(\DateTimeImmutable::createFromMutable($faker->dateTimeBetween('-1 years', 'now')));

            $manager->persist($post);

            if ($i % $batchSize === 0) {
                $manager->flush();
                $manager->clear();
                echo "Inserted $i records...\n";
            }
        }

        $manager->flush();
        $manager->clear();
    }
}
