import HeroSection from "$lib/components/Sections/HeroSection.svelte";
import ProductsSection from "$lib/components/Sections/ProductsSection.svelte";
import NewsSection from "$lib/components/Sections/NewsSection.svelte";
import ContactsSection from "$lib/components/Sections/ContactsSection.svelte";
import PartnersSection from "$lib/components/Sections/PartnersSection.svelte";
import UniversalFormSection from "$lib/components/Sections/UniversalFormSection.svelte";
import FeedbackSection from "$lib/components/Sections/FeedbackSection.svelte";
import EntityListSection from "$lib/components/Sections/EntityListSection.svelte";

export const sectionComponents = {
  hero: HeroSection,
  products: ProductsSection,
  news: NewsSection,
  contacts: ContactsSection,
  partners: PartnersSection,
  form: UniversalFormSection,
  feedback: FeedbackSection,
  entity_list: EntityListSection,
};