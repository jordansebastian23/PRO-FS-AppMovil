# Generated by Django 5.1.2 on 2024-10-26 20:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='firebaseuser',
            name='password',
            field=models.CharField(blank=True, max_length=128, null=True),
        ),
    ]
